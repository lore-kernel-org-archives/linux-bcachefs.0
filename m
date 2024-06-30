Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8763D388
	for <linux-bcachefs@vger.kernel.org>; Sun, 30 Jun 2024 08:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719734633; cv=none; b=bq3BqINlVtYqk/lTHR1p1c2TLFWpsyEgCDjl2mB/1ErwuKkVc5mla5wCKMx5XVvWxywNiN0ewPvgEoWHfy2iYE3+kOjux/OYbIMgX5oq/iEoDcy++DEL2yRz004uuGc/iFmFWHFbKak+GpToErNdOFw2LPwF/Hrl3BHAJDgY9e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719734633; c=relaxed/simple;
	bh=bzPU5OcWcs+4d6MetliRDkTp3jg7Ouucy4tYqbCiUkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ILcA4yyMNEYLsEc720323Kn8zooLOZtpigdTblI8OKY6qswuWRzptWQWvoeNerjjx5ezqtez1xwTJ8BoPlSax+r4ctYoMpB8l9KqppP2SGYRbspD0Z+0tvFVlLDGpqn39SG1tn+t3Za+iDc1C87OBmROuqiNUGBi+N2Ifax7XY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id EAF1F3B691;
	Sun, 30 Jun 2024 08:03:40 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject:
 Re: rsync stuck in "D" state short after starting to copy to a newly created
 filesystem
Date: Sun, 30 Jun 2024 10:03:40 +0200
Message-ID: <2739349.mvXUDI8C0e@lichtvoll.de>
In-Reply-To: <yeufrfd5uy3qhjrzreqg6txlwelx36e7ywobbvvhqzl4cfjzlu@twptk6kdfufr>
References:
 <22338011.EfDdHjke4D@lichtvoll.de>
 <yeufrfd5uy3qhjrzreqg6txlwelx36e7ywobbvvhqzl4cfjzlu@twptk6kdfufr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Kent Overstreet - 30.06.24, 01:09:04 CEST:
> > For a regular unclean shutdown I would not have expected any
> > filesystem
> > errors. A subsequent call to "fsck.bcachefs" revealed no further
> > errors.
> > 
> > I mounted the filesystem again and tried another time with rsync and
> > it did not seem to get stuck as before. However I felt uncomfortable
> > with continuing with a filesystem that has had errors already.
> > Especially at BCacheFS is still marked experimental.
> 
> This should all be fixed in this branch:
> https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-for-6.9

You found the issue? Great! Thanks.

Thanks for the detailed description on how to look where things may be 
stuck. I will keep it around.

-- 
Martin


