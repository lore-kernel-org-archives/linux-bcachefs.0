Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3F3C433F5
	for <linux-bcachefs@archiver.kernel.org>; Sat, 23 Apr 2022 17:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbiDWRe1 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 23 Apr 2022 13:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiDWRe0 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 23 Apr 2022 13:34:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE941892AD
        for <linux-bcachefs@vger.kernel.org>; Sat, 23 Apr 2022 10:31:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DCE6868B05; Sat, 23 Apr 2022 19:31:23 +0200 (CEST)
Date:   Sat, 23 Apr 2022 19:31:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     hch@lst.de, Kent Overstreet <kent.overstreet@gmail.com>,
        ming.lei@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: bug in bcachefs -> bio_copy_data_iter
Message-ID: <20220423173123.GA29024@lst.de>
References: <YYrwbksSPdtITbEs@moria.home.lan> <84ff96fe-ff4b-b58b-b732-88e87fe0b502@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ff96fe-ff4b-b58b-b732-88e87fe0b502@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Nov 10, 2021 at 08:02:06PM +0800, Coly Li wrote:
>> looks like it should be functionally equivalent), but clearly I'm missing
>> something... wonder if there might be some relation to the bug you guys hit in
>> bcache with bvec_virt.
>>
>> Any ideas?
>
> I experience similar one in bcache code during my recent development,

Can you try this patch?


diff --git a/block/bio.c b/block/bio.c
index 4259125e16ab2..ac29c87c6735c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1336,10 +1336,12 @@ void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
 		struct bio_vec src_bv = bio_iter_iovec(src, *src_iter);
 		struct bio_vec dst_bv = bio_iter_iovec(dst, *dst_iter);
 		unsigned int bytes = min(src_bv.bv_len, dst_bv.bv_len);
-		void *src_buf;
+		void *src_buf = bvec_kmap_local(&src_bv);
+		void *dst_buf = bvec_kmap_local(&dst_bv);
 
-		src_buf = bvec_kmap_local(&src_bv);
-		memcpy_to_bvec(&dst_bv, src_buf);
+		memcpy(dst_buf, src_buf, bytes);
+
+		kunmap_local(dst_buf);
 		kunmap_local(src_buf);
 
 		bio_advance_iter_single(src, src_iter, bytes);
