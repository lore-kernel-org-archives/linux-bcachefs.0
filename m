Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BD02A1BA
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Dec 2025 23:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767138170; cv=none; b=Et0IX8jGAmPPV18XSO9yLpQphk4NXtWCm+ljS5h2HX+UxhX5uU5R4SzNS3Qb6/Zd7ur/7QbUEsvtbOR2kNDB9LtifXt8O6n101yWgQ3iMbyKd+pRs/0/Tsiob8JErRRj4ZSjIjaE6JkA3J2TXljEXmBAUV4nqJJiYAHuSRJwEGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767138170; c=relaxed/simple;
	bh=FY8659EbWj/GniC0ZfI8lzIU/u79HaDkVXcOxCCSHX8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=hwgzm8NgarBQ8YhaF2EMalwrY9W0oKnYK+IYC9V0sNyS4gocQ1MMkWSWZJwRbJJ/3SPBJGTTW1xZ+8e2MeMrp/+un6EeNl2uBsitcdsycO7EUjABK7wrPJhkgMJfcdZ6BBEuE1/tTwSUDIizlBMS8eDo03L3aTRKCbQ6tI/otF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=CSxe45pJ; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="CSxe45pJ"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id E2437240027
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Dec 2025 00:42:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1767138160; bh=cf1plrglMvF4f152iceLuUi2t0nZnIubF/bVguUEjhw=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Transfer-Encoding:From;
	b=CSxe45pJwJ6PH4dWtIIDoDPVx6akw02swQ+QsnClYpSTn/x7PXnZor3vfYPRkSz3e
	 4STGZDWd32QESLGouI2XfVVRTUp6XTClsZCknmPqxFUpQl7qDROu1HmljeL0neZqJ/
	 PWWdi57P2TDBW94kp3H/1MBW2DXY/peax+LSXpStWmBh2p3lh2NCcgxQFvZ6zjngWE
	 OprMGtwhQmua/CmPBSRixYVi0dKVfY2JRRaGB17K2i2C5kiUJBAcHNHagMTbH4Pj2A
	 WICM3JRLaGr9aX5PyFCSjqKc+Y2RisE8nFXzaEu9ggBIK/uC97yra5L+rhYsoBOo7R
	 yDwFxrUvn8Ypw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4dgqQ84P5Sz9rxB;
	Wed, 31 Dec 2025 00:42:40 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 30 Dec 2025 23:42:40 +0000
From: Franz Schultz <franz.schultz@posteo.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Version Control capabilities plus two small unrelated questions
In-Reply-To: <7dgvgc3usnl4nbpivj3wuemprknevx5tudji4ldzqkq7ngvfva@sbdg5tfhjnll>
References: <f284018630d0a24414d38028cd397345@posteo.net>
 <7dgvgc3usnl4nbpivj3wuemprknevx5tudji4ldzqkq7ngvfva@sbdg5tfhjnll>
Message-ID: <a22e9f3803d4c60f878f11366aaeda39@posteo.net>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

I'm also interested in such version control design within the FS where 
you save the current version of a file and then are able to access the 
timeline of all such saved versions.

> In particular is there a standard way to 'follow' the same file along 
> its
> snapshotted versions? Say, ask bcachefs to return the list of 
> snapshotted
> versions by giving input this or that file in the current version of 
> the
> filesystem? Note that if such file was deleted and another with the 
> same
> name created I don't want that new file also to show up. And related
> question, is there any command that would list the snapshotted files 
> which
> have no corresponding in the current version of the file system (for 
> example
> because I deleted such file after having snapshotted it)?

