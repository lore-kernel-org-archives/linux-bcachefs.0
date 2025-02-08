Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76812376F3
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012491; cv=none; b=hClnO2aXMyMaME9LcckKNy0wi0FztG/cvc/3i3Z1N1yibesak7iQTRjCjI5gZQ52f4VYGpn76Wnm0iiQ5yxYt52tO9J1Qp/1kE5wrQAf57KA9ClaHPHrzzv0MgBrHTlJGIDcq7wS3GxC7aQ1VuNUV4yp8SAmFYci2N5isBs2jd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012491; c=relaxed/simple;
	bh=WLWX3PQwhn2JfCREuoGAppG78jN7hJr778FyOx7C+BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fE3YXyNAh8L0pQQNlbVp9wctEMhJWa7OT1lj/V3Vd6o9epeJwSNKVtDU142J2J3IWnqo5BGNluVXsMH5a9IZ6pHAhymSj06vcK2kc9SdW3tz969napo+yghz05EA1p3qn/02KuisyFBCHiQIpWDQfb0CYa+d1GkJfklb5tQSxnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQpSuxwj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQpSuxwj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0p6Hq0bZIHKg+O6vz3m+3T9JAko/ng/zoo2yDHSFvpY=;
	b=BQpSuxwjuZRh7/puvHzXR9ACvPaBCPGTGWP5FDKfWzGsyjqSdoZHnSxtysfwnSD+GzBvyj
	q27Fs7U8H53rRIPD3Rk/VBUl41NSQI9xyvEC6lH/g5ZIXiXdyAB8o8rAFrIytoi6fKxCdS
	dL8U+xydXLHe/nmuWtH3dQHHKESwM24=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-107-dLaCcpoCPlOBKFjOSmfaTQ-1; Sat,
 08 Feb 2025 06:01:23 -0500
X-MC-Unique: dLaCcpoCPlOBKFjOSmfaTQ-1
X-Mimecast-MFC-AGG-ID: dLaCcpoCPlOBKFjOSmfaTQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66F8F1955DDD;
	Sat,  8 Feb 2025 11:01:22 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 17EEF30001AB;
	Sat,  8 Feb 2025 11:01:20 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 00/21] bcachefs: eytzinger code
Date: Sat,  8 Feb 2025 12:00:57 +0100
Message-ID: <20250208110119.546961-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Kent,

here is another update.  Changes:

* Added a self test for eytzinger0_find().

* The patches are now in fully bisectable order, with slightly improved
  patch descriptions.

* The patch that runs the self tests on modprobe has been moved to the
  end of the patch queue.  This patch is useful for testing, but it
  SHOULD NOT BE MERGED.


A git tree of the patches can again be found here:

  https://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux.git/log/?h=bcachefs

Base: v6.13
Head: d79258df8791 ("bcachefs: Run the eytzinger tests on modprobe")


The previous CI test results at:

  https://evilpiepirate.org/~testdashboard/ci?user=kmo&branch=eytzinger

against the previous version of this patch queue and with head:

  94865378e1a3 ("bcachefs: eytzinger1_{next,prev} cleanup")

show a large number of passed as well as failed tests even for upstream
v6.13, so I don't know what to conclude from that.

In any case, there is one failure reporting that eytzinger0_find_ge()
didn't find the first matching element in an array with duplicate
elements:

  https://evilpiepirate.org/~testdashboard/ci?user=kmo&branch=eytzinger&commit=c31c7c659278bc2581ef0c7c4119fe14c7476ea3

This is imtentional and expected because at this point in the patch
queue, eytzinger0_find_ge() hasn't been fixed to always return the first
matching element.  The current version of the patch queue adds the fix
before adding the test, so this failure will be gone.

That being said, as per request, the updated patch queue only enables
the self tests in the last patch, so we wouldn't see failures of that
kind anymore, anyway.


Thanks,
Andreas


Andreas Gruenbacher (21):
  bcachefs: bch2_blacklist_entries_gc cleanup
  bcachefs: EYTZINGER_DEBUG fix
  bcachefs: eytzinger self tests: loop cleanups
  bcachefs: eytzinger self tests: missing newline termination
  bcachefs: eytzinger self tests: fix cmp_u16 typo
  bcachefs: eytzinger[01]_test improvement
  bcachefs: eytzinger0_find_test improvement
  bcachefs: add eytzinger0_for_each_prev
  bcachefs: improve eytzinger0_find_le self test
  bcachefs: convert eytzinger0_find_le to be 1-based
  bcachefs: simplify eytzinger0_find_le
  bcachefs: add eytzinger0_find_gt self test
  bcachefs: implement eytzinger0_find_gt directly
  bcachefs: implement eytzinger0_find_ge directly
  bcachefs: add eytzinger0_find_ge self test
  bcachefs: Add eytzinger0_find self test
  bcachefs: convert eytzinger0_find to be 1-based
  bcachefs: convert eytzinger sort to be 1-based (1)
  bcachefs: convert eytzinger sort to be 1-based (2)
  bcachefs: eytzinger1_{next,prev} cleanup
  bcachefs: Run the eytzinger tests on modprobe

 fs/bcachefs/eytzinger.c             |  88 ++++++------
 fs/bcachefs/eytzinger.h             |  99 ++++++-------
 fs/bcachefs/journal_seq_blacklist.c |   7 +-
 fs/bcachefs/super.c                 |   5 +
 fs/bcachefs/util.c                  | 212 ++++++++++++++++++++++------
 fs/bcachefs/util.h                  |   4 +
 6 files changed, 269 insertions(+), 146 deletions(-)

-- 
2.48.1

