Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X3JyuRfq"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20454B9
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 05:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701782625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DDheIURSyOpXgyH16DTrVGGaUFXKRvQRZBOa3ydUSdU=;
	b=X3JyuRfqJ+lU3Ctd+T5Kpkda8Qot4/ycG5r7jCiisdeWOWHpVdtJNqp9MxPjwys1jGoAT4
	8O2ewhfMfVX3Y0jRQ1w4dP5kVrnDnwU1gbhml8b+Pk3xI/lkB75qfGvW9ZhvrEc+BAUZ+6
	nuFEavt9qT4tkEvOH6MUyIgDeSloQC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-4o6xcvPZMfGs9-W1NrIpmQ-1; Tue, 05 Dec 2023 08:23:43 -0500
X-MC-Unique: 4o6xcvPZMfGs9-W1NrIpmQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83341101A555
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 13:23:43 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 689ED492BF0
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 13:23:43 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/2] a couple more freeze/shutdown fixes
Date: Tue,  5 Dec 2023 08:24:37 -0500
Message-ID: <20231205132439.130755-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Hi Kent,

I managed to catch up a bit on the fsync thing we had talked about
earlier this year. Skimming through the original thread, I think this
mail [1] summarizes things best. The short of it is that we can address
at least a couple of the failures we're seeing with fstests
generic/441,484 with a couple small tweaks in bcachefs and fstests, but
these aren't necessarily the longer term fix.

Firstly, patch 1 is just another unrelated (un)freeze fixup I happened
across when hacking around. I don't know that it currently associates to
any related test failures. I just include it here for convenience.

Patch 2 of this series tweaks the fsync path to be a bit more deliberate
/ less aggressive to help avoid spurious shutdowns. The reasoning behind
this is that if fsync fails, the user can't be certain of the state of
things on disk anyways. What I've observed with this patch is that it
seems to prevent generic/484 failures (though not sure that is
guaranteed) and based on the original thread, it can address generic/441
when combined with an fstests tweak to allow the fs a bit of time to
idle before transitioning to the dm error table..

All in all, I still think this is a reasonable incremental improvement.
I think the longer term fix here is more something like the ability to
retry metadata I/O on failure such that we can be a little less
sensitive to emergency shutdowns. I had managed to hack up a quick
prototype of metadata I/O failure/retries a few weeks or so ago just to
explore how difficult it might be, and it didn't seem that bad IIRC. The
bigger question in my mind is how to deal with journal writes,
particularly if journal I/O is any more frequent than the common
filesystems fstests tends to accommodate (i.e. xfs, ext4, etc.). I
suspect this is worth discussing further in an upcoming call..

Also just as a data point, btrfs skips generic/441 in favor of its own
custom variant in btrfs/146. That test runs the same fsync tool, but it
looks like it sets up a combination of data striping (raid0) and
metadata replication on the fs presumably to facilitate data I/O errors
on single disk errors without triggering high level metadata errors.
This might be another option worth considering for bcachefs if we can do
something similar...

Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-bcachefs/Y+EduoshRHXec+XU@bfoster/

Brian Foster (2):
  bcachefs: don't attempt rw on unfreeze when shutdown
  bcachefs: return from fsync on writeback error to avoid early shutdown

 fs/bcachefs/fs-io.c | 14 +++++++++-----
 fs/bcachefs/fs.c    |  3 +++
 2 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.42.0

