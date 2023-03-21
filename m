Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06509C761A6
	for <linux-bcachefs@archiver.kernel.org>; Tue, 21 Mar 2023 13:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCUNT4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCUNTv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 21 Mar 2023 09:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9599072AD
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679404710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Uqtp0UER39uMtLXQ0DoZbMkSaB5PESCnegfjsvPljt8=;
        b=A/Xaxu0F1QFD9E15vM0fsx8kCODr42UMJyphIymFvoXgAfqTXhNsOm30JSKM0xiyFiPLet
        ch3ox7kr3mMA55QZYsWaMqEu9DkevzQmnv9hynmIpyL1HaJSc8vs/wRqIBYmZJ25i6kd3r
        +MwBLP4jD4DDRUqsHlb2wEa1sfWFyxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-MzZD27EpMgmu3VtA1tU0RQ-1; Tue, 21 Mar 2023 09:18:28 -0400
X-MC-Unique: MzZD27EpMgmu3VtA1tU0RQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C6A8855315
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:28 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 746F385768
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/5] bcachefs: journal stall fixes
Date:   Tue, 21 Mar 2023 09:20:09 -0400
Message-Id: <20230321132014.1438249-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

Here's a few patches related to the journal stall issue with
generic/333. Patch 1 is the prospective fix, patches 2-4 make some
smallish cleanups to the stuck checking, and patch 5 is just an RFC for
the idea I mentioned previously wrt using a timeout. It has some issues
described in the commit log, so I'm just including it here for reference
and discussion in the event it leads to any more interesting ideas. I
think the path it's currently leading down is probably a bit of overkill
for the time being.

I've pushed patches 1-4 to the CI this morning, so we'll see how that
goes. One thing that annoys me a bit about patch 1 is that the seq
zapping presumably puts all of the processed keys at the start of the
sorted list in the write buffer flush slowpath, which then means the
loop starts by walking through those already processed keys.

I was thinking about possibly using a sentinel seq value (i.e.
UINT64_MAX or some such) to land those keys at the end of the list, but
it wasn't clear to me if such a value exists or the entire u64 space are
valid seq numbers. Another idea is to count the total number of
processed && skipped keys in the fast path and just start at that index
in the slow path, but also wasn't necessarily convinced if this is
likely enough to be worth the extra code.

Anyways.. thoughts, reviews, flames appreciated.

Brian

Brian Foster (5):
  bcachefs: more aggressive fast path write buffer key flushing
  bcachefs: gracefully unwind journal res slowpath on shutdown
  bcachefs: refactor journal stuck checking into standalone helper
  bcachefs: drop unnecessary journal stuck check from space calculation
  RFC: bcachefs: use a timeout for the journal stuck condition

 fs/bcachefs/btree_write_buffer.c | 41 +++++++-------
 fs/bcachefs/journal.c            | 95 ++++++++++++++++++++++++--------
 fs/bcachefs/journal_reclaim.c    | 19 +------
 3 files changed, 95 insertions(+), 60 deletions(-)

-- 
2.39.2

