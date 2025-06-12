Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDB4242D98
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 13:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749733848; cv=none; b=M7tM0PCGOlpyJdKmk2ze0DORaTVOZoCO+V6D3n+MBJ01rhzC+G3o/OtZvZxauqqNM6J4D6qhCLNYPmTnU+umMIayJoHkaWLJBb5p99ud8rN2n3dltzOa9u2QzyC3oTfe0To7gPs0dvRljnBFbAfweU+js5/J8fC/snYvSZH/3Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749733848; c=relaxed/simple;
	bh=P7JAyjy5Ml/bPSJVqPBOdf/+xVTIK+6PT6dOQ2d0Bkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IoXb4O2h+OpPxhowx6Zs/0TvMRYtX9K2lb1mxQRPxLlHIuvW++8cEZFAlyJIpS8dOPTWZOvHc22xop7+BPpAbgzL2yjT+WmCrgWVw6mtjd8lxjd3YgMHs0P7XPgihrO87fzOzTqk0ZqFjJVxLFsopbgeKdgWVp7iVE3kELW2hbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 7B8EF10ACDE;
	Thu, 12 Jun 2025 13:04:37 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Hongbo Li <lihongbo22@huawei.com>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Date: Thu, 12 Jun 2025 15:04:37 +0200
Message-ID: <2229760.irdbgypaU6@lichtvoll.de>
In-Reply-To: <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
References:
 <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Kent Overstreet - 31.05.25, 01:16:04 CEST:
> > I have a directory entry that according to ls -l is quite big:
> > 
> > drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
> 
> Yes, this is due to a leftover from the directory i_size patchset that
> had to be reverted. As long as it's not causing issues it'll be a bit
> before I get to it, I've got higher priority bugs I'm working on right
> now (as usual).

On 6.15.2. How can I trigger repair code from commit

bcachefs: Repair code for directory i_size

66c36452163871360f15dc4042dd00612e42cd66

?

Currently still has that odd size.

I tried "bcachefs fsck -k" so far, but so far only while filesystem is 
mounted, as after I dismount it I get back the device node from LVM would 
be busy. But I see no indication as to why.

If fsck in dismounted state would do the trick I can try disabling 
automatic mount on boot.

Again no priority. I do not use SSHFS on that filesystem.

I suppose I could just create a new directory and move over the files from 
the one with the odd size.

However, keeping as is for now. Maybe I can help testing repair code. :)

Best,
-- 
Martin


