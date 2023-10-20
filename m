Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C042ECDB474
	for <linux-bcachefs@archiver.kernel.org>; Fri, 20 Oct 2023 16:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377814AbjJTQBe (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 20 Oct 2023 12:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377792AbjJTQBd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 20 Oct 2023 12:01:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4989C10C7
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Oct 2023 09:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697817641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B6CfM8eUnNi1801m3mQkodqAzw40UTTo5qCum+ze7mA=;
        b=YNGjaOCe2BiOICe50+cvN+/LDnnfTXZi/nGSNNL0Kb8y53CVW/Cb7Tae+mK+cjT44PIOs/
        PoLCHN1l5Jav2W0+TR3RH+YVvhLDyfqqF9SsDILi4NrX4ODG1XXajiPmndxTuIGIvyWLFa
        0mgRB4YcnrBJ+ZdBMDCTFvqFhZRNPbY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-ZEhRBojpP0eSWhdMta4ylg-1; Fri,
 20 Oct 2023 12:00:39 -0400
X-MC-Unique: ZEhRBojpP0eSWhdMta4ylg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67CBE1C06910;
        Fri, 20 Oct 2023 16:00:39 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43AC52026D66;
        Fri, 20 Oct 2023 16:00:39 +0000 (UTC)
Date:   Fri, 20 Oct 2023 12:01:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: update alloc cursor in early bucket allocator
Message-ID: <ZTKkQhiF4aD5ZYpw@bfoster>
References: <20231019132746.279256-1-bfoster@redhat.com>
 <20231019153019.jl73n6ipif7zwc5b@moria.home.lan>
 <ZTFl3jJJi2CoDdJB@bfoster>
 <20231019183803.njsjs4sz7p4zpyfc@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019183803.njsjs4sz7p4zpyfc@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Oct 19, 2023 at 02:38:03PM -0400, Kent Overstreet wrote:
> On Thu, Oct 19, 2023 at 01:22:38PM -0400, Brian Foster wrote:
> > BTW, should this code be protected from no free space situations at a
> > higher level, or should we consider a max retry count or something? I
> > want to be cautious about things like prospective livelocks
> > (particularly if this path is less common) if this retry was effectively
> > dead code due to not updating alloc_cursor.
> 
> It should be limiting itself to a single retry already: on retry, we set
> alloc_cursor = alloc_start, so we won't retry again. Just make sure that
> still works :)
> 

I don't think that actually works due to the whole alloc_cursor not
updating thing, but regardless the "single retry from the beginning"
logic makes a lot more sense to me. With that, here's what I'm currently
playing with:

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 3bc4abd3d7d5..41a7bf24c440 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -402,8 +402,9 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 	struct btree_iter iter;
 	struct bkey_s_c k;
 	struct open_bucket *ob = NULL;
-	u64 alloc_start = max_t(u64, ca->mi.first_bucket, ca->new_fs_bucket_idx);
-	u64 alloc_cursor = max(alloc_start, READ_ONCE(ca->alloc_cursor));
+	u64 first_bucket = max_t(u64, ca->mi.first_bucket, ca->new_fs_bucket_idx);
+	u64 alloc_start = max(first_bucket, READ_ONCE(ca->alloc_cursor));
+	u64 alloc_cursor = alloc_start;
 	int ret;
 again:
 	for_each_btree_key_norestart(trans, iter, BTREE_ID_alloc, POS(ca->dev_idx, alloc_cursor),
@@ -431,13 +432,14 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 	}
 	bch2_trans_iter_exit(trans, &iter);
 
+	alloc_cursor = iter.pos.offset;
 	ca->alloc_cursor = alloc_cursor;
 
 	if (!ob && ret)
 		ob = ERR_PTR(ret);
 
-	if (!ob && alloc_cursor > alloc_start) {
-		alloc_cursor = alloc_start;
+	if (!ob && alloc_start > first_bucket) {
+		alloc_cursor = alloc_start = first_bucket;
 		goto again;
 	}
 

