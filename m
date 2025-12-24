Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1C4800
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Dec 2025 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766592684; cv=none; b=Lm9UGPhxdGHxevLnwsgBfUFHDZIjFrXVCjiCdycjZ6xaDSHwkUf03jFLIHi+jE1aLqiXBsA93kbKG07WbY/LghCuO8NRTY9HPIQFGCoj2cra+LRPIEg0xa2W4feSlUntsLdQhpXgXU4pJeq56ibdMIyFtJenNZx0a4/EKLUl3cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766592684; c=relaxed/simple;
	bh=yOQIVkFT+LuMcpaGrlN55edyn22cjwM/FXq4cCTbBeE=;
	h=MIME-Version:Date:From:To:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=lGJRgTjhi5s86E0Ap2UAGssqHbboOF+kWcu9QSx3ZlKxwVSEpJENjPvVkmRCQ7t9mwd0Hn5RUALTOevTe4i9ARN9ZAl7chKHMSu/0OLF2c/5zRMe1Hw4xmzTEqyvW8wH1T270WnCBscOJ33eUOkXX0WyY9GM86EzSrjZf+HuoaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=KqSO5tta; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="KqSO5tta"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id A290B240027
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Dec 2025 17:11:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1766592680; bh=wK+ZV9aiiOJVATh4aSZXX7E7hSR70g95jO73umAF6UU=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type:
	 Content-Transfer-Encoding:From;
	b=KqSO5ttak98UDm6ylHVMEtcvz3pXrGkLrBX1VozimuS7YE6ci22hfWnrCCntfc/6C
	 yb4jJajQm1jFTY5wK8G1OWkupU/ksMgF/F+yAbZeZXJVMM8c9hCRe36th+teNM/R3g
	 ouUNRRqMC/41/2J6Pm08Y/mWfZwBOy0Sd733/ZfxsqDbBPemH1M9zfjJ5HO8DmX+/5
	 SAU+Gq7OczvrMzZSol1Cjxx/l+So1wkimf20gdUHDgpt6p7nEQJcw7ldrEhcvOLHXf
	 iGL5hQ4IOq6GP3Q685ObWaWSz0xKIDciJBa3E0WjK8HhvfEysCGwZQaYOrlwhsWnhn
	 TOIr6/QKRsmew==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4dbxh82bSvz6tvZ
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Dec 2025 17:11:20 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 24 Dec 2025 16:11:20 +0000
From: BP25 <bp25@posteo.net>
To: linux-bcachefs@vger.kernel.org
Subject: Re: Version Control capabilities plus two small unrelated questions
In-Reply-To: <f284018630d0a24414d38028cd397345@posteo.net>
References: <f284018630d0a24414d38028cd397345@posteo.net>
Message-ID: <57dfdd78aed6d071d4b978b233680a0e@posteo.net>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

Note that when I use the word "snapshotted" by saying snapshotted file 
or snapshotted version of a file, I mean both "A: file that is included 
in the snapshot of a certain volume", and "B: file that was individually 
snapshotted to save a version of it". In fact I think that, if 
individual-file versioning is indeed possible as the first part of my 
question asks, then taking meaning A: or taking meaning B: is irrelevant 
because the code would be essentially the same.
