Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5265DC4332F
	for <linux-bcachefs@archiver.kernel.org>; Mon, 12 Dec 2022 19:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiLLTVc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 12 Dec 2022 14:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiLLTVa (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 12 Dec 2022 14:21:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742BB62D1
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Dec 2022 11:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670872835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=wNzqVgR4sNfBe5XvOhgaJ1Umc8/ZRo7jZ4pauvKpags=;
        b=TpCgRA8UkWR9ACPzmL+MZAYFckM6lxkC/5B4Oxh8enZy60idbYuI/fyIwugcrH0fKNcT4z
        Ux7Q/MmPQVf+4wK0Ws+RseHIzSLoBRStpt+iCZ+ahJMfP3Pv1wczBFRmfVzAtEG2UGjKNP
        RuqRTZADbXrPLnUKLTrBAa0V4GBCcd4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-CcqLPQ_VNv67FmE8TwJqZA-1; Mon, 12 Dec 2022 14:20:34 -0500
X-MC-Unique: CcqLPQ_VNv67FmE8TwJqZA-1
Received: by mail-qv1-f72.google.com with SMTP id o13-20020a056214108d00b004c6fb4f16dcso12379731qvr.6
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Dec 2022 11:20:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNzqVgR4sNfBe5XvOhgaJ1Umc8/ZRo7jZ4pauvKpags=;
        b=znDwdlwuR2rvv4XCXeKf/u3y9XnJl4wyX6MShy+kX58N+uEdmDZA/+aM8Hg822GJN/
         eF3Dn2yTh7uC2jLcXPBriIgOGbAnJi9H7N/YgFNOkM6A4+o2dHxIYvc0P1TocN0uYMWn
         bH8jqrrJPKgTHzGg2fg0RY+caHE6CAevQXQrqyO5yHQTrz0z9LkFZERi22U7FG+9JfKy
         h7bXciAGb3BWYZ+Nnfl76r+wlGaujxAXu1KETrDRifOj6bB8OZz5p8zB1klVjoofkBG6
         VOysW5SW675EC80GHmGQNAggdv5oUfHyvF0IefUX15eksPDSURLzm0prAsrfTp3WQSKY
         GqBQ==
X-Gm-Message-State: ANoB5pkyc6+3kQl+h30v28IzSsyK2bCe3RwrWjBgGe+/mvE/duv1EpZV
        P0A4DfzNphFOVmoV3y8Zsv8dH067o+la0dBU32tK8fI1NSA9+BrgHkPc/fJsV02bih/xLwb3fSM
        yOWLZwcS4vWpUDV07HMy4eGqSe9JRmkDGJbvhRJZ9QpgB9Py8oQwQhoavbuinnPMIPuo66k2eY/
        z7ag==
X-Received: by 2002:ac8:50a:0:b0:3a6:95ff:ffd4 with SMTP id u10-20020ac8050a000000b003a695ffffd4mr20510839qtg.52.1670872833354;
        Mon, 12 Dec 2022 11:20:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5LEpcgeRy8CW8JWlguzjBhz99hUuhqHrennGbL/umiwU0K1Kb6NhhSCr3hW/zNv+DuQLh1yg==
X-Received: by 2002:ac8:50a:0:b0:3a6:95ff:ffd4 with SMTP id u10-20020ac8050a000000b003a695ffffd4mr20510817qtg.52.1670872833001;
        Mon, 12 Dec 2022 11:20:33 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bv14-20020a05622a0a0e00b003a57eb7f212sm6308774qtb.10.2022.12.12.11.20.32
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 11:20:32 -0800 (PST)
Date:   Mon, 12 Dec 2022 14:20:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [BUG] trace_printk() broken?
Message-ID: <Y5d/B88BOu6qOE5X@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi,

While poking around the bcachefs tree I ran into a problem where
trace_printk() seems to be broken. I suspect this has something to do
with the printbuf bits as it works once I back out some of those
changes.

What I observe is that a smaller printk with a fixed string seems to
work as expected, but once I add some variable args the message string
seems to get chewed up. This results in wonky formatting when reading
/sys/kernel/debug/tracing/trace and a read of the corresponding
trace_pipe file seems to spin in a livelock.

A diff is appended below to give a simple example of each case. A read
of the trace file ends up looking like this:

       fsck.ext4-535     [003] .....     6.112680: write_cache_pages:        fsck.ext4-535     [003] .....     6.113224: write_cache_pages: test
       fsck.ext4-535     [003] .....     6.117957: write_cache_pages:        fsck.ext4-535     [003] .....     6.118445: write_cache_pages: test
...

Brian

--- 8< ---

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 032a7bf8d259..59ae76cb5756 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2355,6 +2355,9 @@ int write_cache_pages(struct address_space *mapping,
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
+			trace_printk("%d: ino 0x%lx\n", __LINE__, mapping->host->i_ino);
+			trace_printk("test\n");
+
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 			error = (*writepage)(page, wbc, data);
 			if (unlikely(error)) {

