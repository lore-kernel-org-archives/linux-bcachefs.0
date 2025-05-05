Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973A13C3F6
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 May 2025 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746453358; cv=none; b=j2zyuwZLWUjcKQqoqiOxrunWkr7tUIOAQ8vlslzZ7s1ZHmffvbavcdKGafv1r+engPMhbX0lTH6mBz8jS9bSPlAkPTtGjUgAQhvd6VUl20JgpD4UerWLtv+RGFwi/zDMPurQNOtx3ODa9g6GOnb/LclJs3LdFsAY9mKwAnUa4J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746453358; c=relaxed/simple;
	bh=37kT7C4c/c/BVxK3pOrkTB887jVDgrtzhYOcjpxu3ps=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=c2GVhEzvotKjByGixpRcdBkwWOgPZQPetsuu1+TMwNn49Lsujg+p+dIKD34oWbaEz+cOjja8uOMYhZJGHU0cREvfsyDNrEVLoipOdWQ0vu5GXXw60t9Cdyxl0uqsS6jqbEvGt0qBq2cwDgPovKvhUz78hrMUzMGDVL1cKh6BqMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=siGy6ILg; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="siGy6ILg"
Date: Mon, 5 May 2025 09:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746453353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=XtRLUheaE6ilPFXAGDwguzy1lOFBtvV+bN2uo0xvyms=;
	b=siGy6ILgK/Y0W4UUvexjxYR/kIdn1N25HrWcgAk00XQDKUvg91eedSNsAdL1mgbqqHwobc
	QGoGnNA+GmCW62uVTDQRPWS4PV/LrCSS++Vap747rtFXcuaw5/R9BbEy8sZ0GaZfM2OqYG
	IJ4DcySGDcnuyah83S6wdvI86xI3NhE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-bcachefs@vger.kernel.org, stable@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.12.y
Message-ID: <3bje6r3eacjrffmvayjgoaxrz3rowplfvq73vlm5oq3cx4vdow@b7mr6c6nbzwv>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

The following changes since commit 1a7a2300e0dd8b4a73bcd3777a2947fe42a16bef:

  bcachefs: bch2_ioctl_subvolume_destroy() fixes (2025-03-31 13:16:15 -0400)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-for-6.12-2025-05-5

for you to fetch changes up to 3f105630c0b2e53a93713c2328e3426081f961c1:

  bcachefs: Remove incorrect __counted_by annotation (2025-05-05 09:41:26 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.12

remove incorrect counted_by annotation, fixing FORTIFY_SOURCE crashes
that have been hitting arch users

----------------------------------------------------------------
Alan Huang (1):
      bcachefs: Remove incorrect __counted_by annotation

 fs/bcachefs/xattr_format.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
