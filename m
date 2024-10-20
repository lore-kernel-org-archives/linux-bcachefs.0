Received: from mail.af.tnxip.de (mail.af.tnxip.de [212.53.203.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3B6BA2D
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 08:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.53.203.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729411497; cv=none; b=oduvu5wFHpqL9W4gYRzKDGgVFUu+YGDif+iJyfufqmGfuXTQNDCbiBeSHBp+TVOd5qzD8t5HW4WldUunVyiDdK/3o0lKpM7ZaWrjYzivL+SKjyzW3x7Gj2O+/jky1v+dQIRtqjQfD67Ogsr2MKXSVfRGn21BROXTeCUtsBlbQc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729411497; c=relaxed/simple;
	bh=UCDQrzJxWeAh45S+4mojOa6wSnbIe9VwUvYRP469bgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B8FP0fLuRQoBeJkyFxKI9jEkDs+/v18KpV8sAwsKsZMgk5Ssg0zLCtW9HV5/WOexgAPWoFm/KMoBsouCQ/V11Ss5bxAOCgT0cStYvJ+VHNZ30yxEKCili0LeClkAoXfAXE6Wd7qoLyxAe4Gldn6e90ve+IpqHmoy/Xc6e1kOG2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=n9D856TD; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=oF5wPu1k; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=pcuzsABH; dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=E75rhja2; arc=none smtp.client-ip=212.53.203.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="n9D856TD";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="oF5wPu1k";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="pcuzsABH";
	dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="E75rhja2"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:3105:6f5:383f:9aa1])
	by mail.af.tnxip.de (Postfix) with ESMTPS id D2AEE20185;
	Sun, 20 Oct 2024 10:04:39 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1729411479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEbGHDw+A61Ib3JiwbSVYsKe+HDCy8J4c8zZhZ2wyak=;
	b=n9D856TDJcrc2c1BimWK1vXgU6/loOHF5SrAyjkt2QosgrKI5OVPzqIET7y7e0AwemHxXW
	UocQa2VkkoZ4aBAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1729411479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEbGHDw+A61Ib3JiwbSVYsKe+HDCy8J4c8zZhZ2wyak=;
	b=oF5wPu1kWnp9w5jKphdNsC+i25Lxcsieqq+CYDuAndaMlODro2yZ2FKKoRXZVB3Ri5nsH8
	AXLil0ipcCZFc6q6UAK0OlbgctBJtmFhEaDRLybvufZF61sQ8GmRdzA7+1Y7N/fwpDDuet
	dhgZWRghs6t9wfO9vtD2iCJqMsXvyKE=
Received: from [IPV6:2a04:4540:8c02:ed01:9fce:adea:e603:6044] (highlander.local [IPv6:2a04:4540:8c02:ed01:9fce:adea:e603:6044])
	by gw.tnxip.de (Postfix) with ESMTPSA id 892CD20085B34;
	Sun, 20 Oct 2024 10:04:36 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1729411479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEbGHDw+A61Ib3JiwbSVYsKe+HDCy8J4c8zZhZ2wyak=;
	b=pcuzsABHETAOBGbPd765DSGlJOYuwiLibMi1X1+vYenm3gc4pKhOeVdpLMJMIoV7l7XCms
	zI5qqLw4X1u1ucBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1729411479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEbGHDw+A61Ib3JiwbSVYsKe+HDCy8J4c8zZhZ2wyak=;
	b=E75rhja2H7Tm7GHQ+NehmR4T/8BQ/a2s3w5TILBajf64J13LYeRCXOY2UOgRUsDQP5qfOy
	HKPcAQ1RbYdxMGUQig15XA3RQ85NDPF+QPdY38TIG8dhce1Xj24fBzgLDMVYZl/dlRq/io
	Uvs3ONeafkOrAEOyQFan8dHVhO18FHA=
Message-ID: <ad14ee04-1e41-437d-be46-ac736a0292e4@tnxip.de>
Date: Sun, 20 Oct 2024 10:04:35 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: Another bcachefs version downgrade bug
To: Jani Partanen <jiipee@sotapeli.fi>, linux-bcachefs@vger.kernel.org
References: <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
 <1af6fd38-7ecf-451a-9be3-fa7b9447fa43@tnxip.de>
 <4958287.GXAFRqVoOG@lichtvoll.de>
 <89e7e2d1-6c1f-4ff0-a645-5d9308dc81db@sotapeli.fi>
Content-Language: de-DE, en-GB
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
In-Reply-To: <89e7e2d1-6c1f-4ff0-a645-5d9308dc81db@sotapeli.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/10/2024 22:18, Jani Partanen wrote:
>
> On 19/10/2024 11.31, Martin Steigerwald wrote:
>> BCacheFS is marked experimental. My take with that is: As long as it is
>> marked experimental and you like to test it and give feedback, it is
>> important to move quickly enough to new kernel versions. It was and 
>> partly
>> still is the same with BTRFS. Developers often asked users to use a 
>> newer
>> kernel. Feedback on BCacheFS on 6.9 is quite likely not very useful to
>> Kent and other BCacheFS developers while they already work on what to
>> bring in for 6.13.
>
> Issue is that normal user have no idea that bcachefs is experimental 
> because it is only told to be experimental IF you are building 
> building kernel yourself.
>
> - modinfo does not say anything about experimental
>
> - bcachefs user tool does not say anything about experimental. iirc 
> btrfs user tool warns that you are going to use experimental stuff 
> when you select raid5
>
>
I think the only place where that can be done sensibly (even 
retroactively) is in the distro's package manager when one installs the 
tools. Might have been something that could have been in the format 
sub-command, but it's way too late for that now.
