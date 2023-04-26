Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C05C77B60
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 12:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbjDZMcm (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 08:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbjDZMcl (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 08:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ECD619A
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 05:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682512281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=HzFNExPmr5OrvEIhsGbKEiR1/8oi9hrMbuVmbis8tpQ=;
        b=Auu75zeGiACNHndXLeQfRM0Kjg92Syo3NRSCe258STZTheGkGKPbKSU6HMe1+oJBMYhHEt
        eCqfIInY7PqpMwKXnxrhyKGt6krJ7j56Yb1gxRJ1YJ0Y83HWohEhxJ/31mSo1k7WnUwBGe
        2O+j8EzQrrcFCkSkezennSEw8Tyq2Xw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-eoP8MyXHMTKaVZgNhMdh9Q-1; Wed, 26 Apr 2023 08:31:20 -0400
X-MC-Unique: eoP8MyXHMTKaVZgNhMdh9Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D74A281723B;
        Wed, 26 Apr 2023 12:31:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 695F5492B03;
        Wed, 26 Apr 2023 12:31:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 33QCVAGR000983;
        Wed, 26 Apr 2023 08:31:10 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 33QCVAIS000979;
        Wed, 26 Apr 2023 08:31:10 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 26 Apr 2023 08:31:10 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Kent Overstreet <kent.overstreet@linux.dev>
cc:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] A small compile fix
Message-ID: <alpine.LRH.2.21.2304260820020.428@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi

Here I'm sending a small compile fix for bcachefs-tools.

Without this patch, I get this error:

cargo  build --release --manifest-path rust-src/Cargo.toml
   Compiling bch_bindgen v0.1.0 
(/usr/src/git/bcachefs-tools/rust-src/bch_bindgen)
error: failed to run custom build command for `bch_bindgen v0.1.0 
(/usr/src/git/bcachefs-tools/rust-src/bch_bindgen)`

Caused by:
  process didn't exit successfully: 
`/usr/src/git/bcachefs-tools/rust-src/target/release/build/bch_bindgen-733e88995ce9eab7/build-script-build` 
(exit status: 101)
  --- stderr
  warning: optimization flag '-fkeep-inline-functions' is not supported 
[-Wignored-optimization-argument]
  ../../include/linux/bit_spinlock.h:20:3: error: call to undeclared 
function 'futex'; ISO C99 and later do not support implicit function 
declarations [-Wimplicit-function-declaration]
  ../../include/linux/bit_spinlock.h:28:2: error: call to undeclared 
function 'futex'; ISO C99 and later do not support implicit function 
declarations [-Wimplicit-function-declaration]
  ../../include/linux/bit_spinlock.h:39:2: error: call to undeclared 
function 'futex'; ISO C99 and later do not support implicit function 
declarations [-Wimplicit-function-declaration]


The futex() function is declared in 
	/usr/include/x86_64-linux-gnu/urcu/futex.h
It is not declared in linux/futex.h, so we need to include urcu/futex.h

Mikulas


---
 include/linux/bit_spinlock.h |    1 +
 1 file changed, 1 insertion(+)

Index: bcachefs-tools/include/linux/bit_spinlock.h
===================================================================
--- bcachefs-tools.orig/include/linux/bit_spinlock.h
+++ bcachefs-tools/include/linux/bit_spinlock.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/preempt.h>
 #include <linux/futex.h>
+#include <urcu/futex.h>
 
 static inline void bit_spin_lock(int nr, unsigned long *_addr)
 {

