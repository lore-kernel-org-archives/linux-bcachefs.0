Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1030DC7EE23
	for <linux-bcachefs@archiver.kernel.org>; Tue, 30 May 2023 12:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjE3MRA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 30 May 2023 08:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjE3MQ6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 30 May 2023 08:16:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D68812A
        for <linux-bcachefs@vger.kernel.org>; Tue, 30 May 2023 05:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685448943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=yWWe44bm69aNwJrWW7nWhUPk4skTtKrqIlbs7lL94YE=;
        b=ied4upK4qCuc+jnHwfYaCAQ9No7ZvCbI5NRN9GMqPbNkNrRSfkaeeYf+8uBI6Ies31DSn/
        ESSSme4PYIKUZY+oA/w7Pc6Yq6XDum/pShqv13ecbPjR0nZOiA3e8eOQft20qUuPzxPM+s
        YNGJipiDK+j0viCoL/5+8HruUvV/0yo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-15eK25lbPfOGa5tgr8EBTw-1; Tue, 30 May 2023 08:15:41 -0400
X-MC-Unique: 15eK25lbPfOGa5tgr8EBTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A10F85A5BA;
        Tue, 30 May 2023 12:15:41 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63434112132C;
        Tue, 30 May 2023 12:15:41 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 34UCFfYp013621;
        Tue, 30 May 2023 08:15:41 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 34UCFfL8013617;
        Tue, 30 May 2023 08:15:41 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 30 May 2023 08:15:41 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Kent Overstreet <kent.overstreet@linux.dev>
cc:     linux-bcachefs@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] bcachefs: fix NULL pointer dereference in try_alloc_bucket
Message-ID: <alpine.LRH.2.21.2305300803220.12797@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On Mon, 29 May 2023, Mikulas Patocka wrote:

> The oops happens in set_btree_iter_dontneed and it is caused by the fact 
> that iter->path is NULL. The code in try_alloc_bucket is buggy because it 
> sets "struct btree_iter iter = { NULL };" and then jumps to the "err" 
> label that tries to dereference values in "iter".

Here I'm sending a patch for it.



From: Mikulas Patocka <mpatocka@redhat.com>

The function try_alloc_bucket sets the variable "iter" to NULL and then
(on various error conditions) jumps to the label "err". On the "err"
label, it calls "set_btree_iter_dontneed" that tries to dereference
"iter->trans" and "iter->path".

So, we get an oops on error condition.

This patch fixes the crash by testing that iter.trans and iter.path is
non-zero before calling set_btree_iter_dontneed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/bcachefs/alloc_foreground.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: bcachefs/fs/bcachefs/alloc_foreground.c
===================================================================
--- bcachefs.orig/fs/bcachefs/alloc_foreground.c
+++ bcachefs/fs/bcachefs/alloc_foreground.c
@@ -371,7 +371,8 @@ static struct open_bucket *try_alloc_buc
 	if (!ob)
 		iter.path->preserve = false;
 err:
-	set_btree_iter_dontneed(&iter);
+	if (iter.trans && iter.path)
+		set_btree_iter_dontneed(&iter);
 	bch2_trans_iter_exit(trans, &iter);
 	printbuf_exit(&buf);
 	return ob;

