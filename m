Received: from mail.tnxip.de (mail.tnxip.de [49.12.77.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72F202978
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.77.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742333855; cv=none; b=b/7nO+svkLnUWFdfr78cq/XAqs+aqHzUfBUo8BgmCDkxrLJuZPq4Q36FppYOvPhHYAqjtGxl6qtkWeCeRzVZfpjzz76EEbnEgGQ/RjGf4VUHCBvAq+nyJEB84001HYu5g+wWbmL6dRqwDxaHxQ8dNpYT+VvgSTr12YKD/w2shxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742333855; c=relaxed/simple;
	bh=hpDVAKsSkF/h3wEKwidZ+fDlC691WLRL2r+2ukfzmAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kACmcO7PZNtpv43cIvVuAhj/nkhqHlOtmyiQQvfScEveh30oPYlJxnvNldJRZnAgbfEfWD7UAW8osAP9+eBVB2xDCzjv/bwEewktQN87Tma/y/EXKc40erwSIvMwxrr0/IYa0LcTfubqRKANFB0s8Edvb/hGflNTOxfnI9WLNiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=ij2UJd3i; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=Zz7beNY8; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=OfwBQhEL; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=HIW7y2M5; arc=none smtp.client-ip=49.12.77.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="ij2UJd3i";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="Zz7beNY8";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="OfwBQhEL";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="HIW7y2M5"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:c83d:cb3f:e48:c15a])
	by mail.tnxip.de (Postfix) with ESMTPS id 4624E208B2;
	Tue, 18 Mar 2025 22:32:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1742333526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWpt/rbJ4CNby9pswnfkaqUQIzgjHKBmmbE/W4a/+MQ=;
	b=ij2UJd3ieXt8mIsN3WtY0c5Nxsf6H+evPhQOjzf2YOME01Sa9LaM/IV8uhTPijIK7TRIgn
	WmDMDSFknDwIKjsL/907gSPGSdsrSHSc3iHUC8bAkqBG3RK+R561bpTES2GQbRmwuWpr76
	OTDntHIqsuO5RpqzGWdAEOmE5rCybIw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1742333526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWpt/rbJ4CNby9pswnfkaqUQIzgjHKBmmbE/W4a/+MQ=;
	b=Zz7beNY8CAsSPaNGCSgKddJsyzVF4GOof6ybQwEmvv5+RNqo4hvx7zjfUsCm60RVuHVbMj
	8DpBuPhZDGJmexDQ==
Received: from [IPV6:2a04:4540:8c01:f100:ff2f:9ba1:7ab2:87d3] (unknown [IPv6:2a04:4540:8c01:f100:ff2f:9ba1:7ab2:87d3])
	by gw.tnxip.de (Postfix) with ESMTPSA id EAEC52800000000001AE1;
	Tue, 18 Mar 2025 22:32:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1742333521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWpt/rbJ4CNby9pswnfkaqUQIzgjHKBmmbE/W4a/+MQ=;
	b=OfwBQhELhEmpSrTyjNHZaQQUI7C5ZHHi0WkJP0Uk8IfiO5TY/pndwWou1bPbo+Wjdo05qD
	obOLa/bwrFJEngfGpNirtvIJcx2suDNqKDiUoimf0DrhxZ2Yli/5mbjTF0rrqIsoffxjrz
	gLB9BWilcmhHbHXLDM8rw+lte/hD3QY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1742333521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWpt/rbJ4CNby9pswnfkaqUQIzgjHKBmmbE/W4a/+MQ=;
	b=HIW7y2M5tT44ACd270Z+JAXkWYl2sjHh9yNeRNlkLSM9vDBhvAvCt7Om6ddVZFFBOGoHAd
	ym7uZ8AmRaIeWvAw==
Message-ID: <3e765804-93b5-4102-8d31-0c91d44c726c@tnxip.de>
Date: Tue, 18 Mar 2025 22:32:00 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: errors compiling bcachefs-tools v1.20.0 on debian 12
To: John Stoffel <john@stoffel.org>
Cc: linux-bcachefs@vger.kernel.org
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <26584.35900.850011.320586@quad.stoffel.home>
 <26584.36927.6100.282713@quad.stoffel.home>
 <66bf47fc-643e-4e6b-ab6d-492024fdd2e7@tnxip.de>
 <26585.57291.760395.430511@quad.stoffel.home>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
In-Reply-To: <26585.57291.760395.430511@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/03/2025 22:04, John Stoffel wrote:
>>>>>> "Malte" == Malte Schröder <malte.schroeder@tnxip.de> writes:
>> Libs in Debian 12/Bookworm are too old for bcachefs-tools. I think
>> someone pulled it of by forcing some libs from Trixie, but that caused
>> other things to break.
> So what is the best Linux distro to use to compile bcachefs-tools?
> And can someone upgrade the INSTALL.md doc and the
> https://bcachefs.org website to talk about what is the best
> development environment now to use as a baseline?  And how to
> cross-compile the bcachefs-tools for use on older distros with newer
> kernels?  
>
> I'm sure more people would test and play with bcachefs if there was
> more docs for ends users to work from.
>
> John

I'd recommend you join #bcache at OFTC. This kind of things has been and
still is discussed there and people have found solutions that worked for
them regarding -tools vs Bookworm. My personal "solution" was to upgrade
to Trixie.

/Malte

