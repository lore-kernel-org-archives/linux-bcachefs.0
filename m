Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1991373
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Dec 2025 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766592127; cv=none; b=j4MAICiModR/WuK/ZEsvsRsbO3O32RDEJjmDK0sDh/gGvl04cRBK5uE0Aq/Dnb5tHZVvYXizndjHc+GFjrDPZOeSuEKMadyz8ytSdlePBg0dz3t0+5jA9SD3XnuFPWeTK/75iJyXIi1P0wASN/sXdgUpJ0/zm9K2Y65JZ075aww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766592127; c=relaxed/simple;
	bh=KDXUwmwUQ2cIPP/tvNRsPQKw2vXAf9QyBVG6mkGPdYw=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type; b=SDADgn410VVG8bKZSJvh7T3ononLSWmfYMyrb3xvQyL9oOGFkv+aiJFqCreX61D6FzbEoxyDxSxzkdT7bObXinNH1uhMSYK5YZbPcgqJXw7YecuCgeMlov/VSqQpSUPoeorbPelSJQTHNzkR5BT850ZB0azAXhwwMDNZMZQPOys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=EiHtkqxd; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="EiHtkqxd"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 23BD0240027
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Dec 2025 17:02:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1766592122; bh=LeSr4NcIAK/E4YEumSjCn+7wy1NNdiuHUpscGAxT6I8=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type:
	 Content-Transfer-Encoding:From;
	b=EiHtkqxdepIDb86ZG+W3sVoyX8/7qcNIFKnpXueY14GXnVon2MAzRtjPrP3bq8N4U
	 xM2esn2wwmlJwNwNOV4IjbMs6W7vzKesKA17Szj9uIhARoYfF13pao4kkKP++aOpdp
	 W2fEyNYtk46CvIh97efbhUVFc6mYbO/Pka/2+ljStn1+cKC+738LRE0m3HRWg0cqj6
	 HVVNYiYtBVU36YwbKuXhB+DGyO+3uejMYFDa9cfIPHS1s4Zt1YeDwWmjv4jZtlfFly
	 iR2pKmN3FLw7pltx8kQPVbdrXr2K3C4QmZOkCpYxVF9n5CR9eAqZ54nGUFCv49cncB
	 HTrfkfRpDPYuw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4dbxTP69XQz6tvZ
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Dec 2025 17:02:01 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 24 Dec 2025 16:02:01 +0000
From: BP25 <bp25@posteo.net>
To: linux-bcachefs@vger.kernel.org
Subject: Version Control capabilities plus two small unrelated questions
Message-ID: <f284018630d0a24414d38028cd397345@posteo.net>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

Hello, would someone kindly advise whether bcachefs supports file 
versioning, somewhat in the spirit of Stallman (lecture at KTH Sweden in 
1986) where files are individually versioned (as opposed as taking 
snapshots of entire volumes) but the versions are not just ordinary 
distinct files, they are hidden files connected with each other.

In particular is there a standard way to 'follow' the same file along 
its snapshotted versions? Say, ask bcachefs to return the list of 
snapshotted versions by giving input this or that file in the current 
version of the filesystem? Note that if such file was deleted and 
another with the same name created I don't want that new file also to 
show up. And related question, is there any command that would list the 
snapshotted files which have no corresponding in the current version of 
the file system (for example because I deleted such file after having 
snapshotted it)?

First small unrelated question: do you confirm that standard Guix is 
currently incompatible with bcachefs as root filesystem and is there any 
plan to patch Guix so that it's possible (with standard Guix 
installation)? Note: "Currently Guix System only supports ext4, btrfs, 
JFS, F2FS, and XFS file systems. In particular, code that reads file 
system UUIDs and labels only works for these file system types."

Why does the generation number in bcachefs snapshots starts from U32max 
and goes down, instead of the naive start from 0 and goes up? There must 
be some strong conceptual reason for doing the first because I see 
already a few small conceptual reasons to do the second.

  Please CC or BCC me because I'm not subscribed ro the mailing list.

