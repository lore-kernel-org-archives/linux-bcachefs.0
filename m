Received: from mail.tnxip.de (mail.tnxip.de [49.12.77.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5B3B664
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.77.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747473363; cv=none; b=YXS68TZUDUSCrxHS7zdu7zTfFFaAtbmd60k2kPbA+9iAYekQyRsgGBRXwbl6hvrqo6+3URmQIIQqHx5W6tmJnZXOrOtU4csfxTjLnwigLog5m4d8MfSsaUQ9ewllMF55ENMDUStVyW0U9+yt4RXPMzLc7c8yoSZ0GlKLuX69Zdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747473363; c=relaxed/simple;
	bh=adVfjFBqy6jLjYmfmxjGufv3KqBamaR7RPblbS7jEys=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XGQkAFHRdFtpiDJM/A5sEEtkt6FadGNPwwg7yjgX7Z7jA9uVPjI8NTes+Qv2ictqGiN7YIrsrorkixEKZ2RiMoEsSSfLIFWmMAThVMiLfABxHzd+K59g/82yypOw2SmITuqUiyWM97TmwmlhyHXgn/hq9Smnm8ZFsuDjcZCrN1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=Wb9GvSPq; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=LDtIBdE2; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=SJ6KCetW; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=Uzd+saRK; arc=none smtp.client-ip=49.12.77.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="Wb9GvSPq";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="LDtIBdE2";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="SJ6KCetW";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="Uzd+saRK"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:a4c6:597:2a14:e443])
	by mail.tnxip.de (Postfix) with ESMTPS id 8D656208AB;
	Sat, 17 May 2025 11:15:49 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1747473349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1I8WnhIA6KaQmrONhBFupvBkPzGJ1st2IVRYX1JurQ=;
	b=Wb9GvSPqv//bKZk62bezCjB+7UQEZPKegJ/0cVuRF2roa9Iw7vX/pWPW0LyAth7AMDjZEe
	GksuJItX0Wdij7BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1747473349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1I8WnhIA6KaQmrONhBFupvBkPzGJ1st2IVRYX1JurQ=;
	b=LDtIBdE2oyWcfZg6FNdO+j481MwFpuKvyPJGhrGvuOM+dHoBjpmbu32q32uB8PCLtL8feH
	sUzWHJ1u8OdkOUhVI3cJgElF+1odEvTGP60h+dF5wqpFe3ZQHeUn4PwVsyHKhb3KGg2eI/
	ZcuLA9aw/J8CR3PuTYkbmfVU07iy+70=
Received: from [IPV6:2a04:4540:8c09:8c00:7f69:c40:c544:7ff3] (unknown [IPv6:2a04:4540:8c09:8c00:7f69:c40:c544:7ff3])
	by gw.tnxip.de (Postfix) with ESMTPSA id D294154000000000386E4;
	Sat, 17 May 2025 11:15:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1747473348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1I8WnhIA6KaQmrONhBFupvBkPzGJ1st2IVRYX1JurQ=;
	b=SJ6KCetWMU7BWC4BqK5F2IDunFfus+d+fSkCr5CsDdzbSvD5vQW6uV5bbcoo79B05uh5Nq
	9uSzlQZjmOXANGKHiYpbUOfgQr62ew6RUjnqypRe5oNgnbmjGasLBD9J02REoZaGRNeBIJ
	upIzaTZvaEzNA/a+GFxSqX5zMcd/sUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1747473348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1I8WnhIA6KaQmrONhBFupvBkPzGJ1st2IVRYX1JurQ=;
	b=Uzd+saRKPM4h5V44jtG7EVAyW/qd6wyWSBgO5B6JPU7KisP89f1glGcIQJMaUgxAJSQzXj
	ckSxsbU2HEtksEBQ==
Message-ID: <7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
Date: Sat, 17 May 2025 11:15:39 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: Status of rebalance and scrub support
To: Martin Steigerwald <martin@lichtvoll.de>, linux-bcachefs@vger.kernel.org,
 Pavin Joseph <me@pavinjoseph.com>
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <c76f1900-de04-422e-b6eb-12453d982ddf@pavinjoseph.com>
 <4984817.GXAFRqVoOG@lichtvoll.de>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
In-Reply-To: <4984817.GXAFRqVoOG@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 17/05/2025 11:12, Martin Steigerwald wrote:
> Hi.
>
> Pavin Joseph - 17.08.24, 19:17:18 CEST:
>> Gentle ping, anyone? 🥺
>>
>> On 8/7/24 11:07 AM, Pavin Joseph wrote:
>>> Hello everyone,
>>>
>>> Is there an ETA available for full rebalance and scrub support?
> I take it that scrub support is not yet fully implemented?
>
> I am not really asking for an ETA – it will be done when it is done – 
> however I am not sure whether scrub is not yet fully implemented or 
> whether I am facing a bug:
>
> % bcachefs data scrub /mnt/tmp
> Starting scrub on 1 devices:  dm-6
> device   checked   corrected uncorrected  total
> dm-6     0 B         0 B         0 B      17.2 GiB    0%  0 B/sec
>
> (quick test filesystem formatted with bcachefs format without additional 
> options on LUKS encrypted LVM)
>
> Stays there until I Ctrl-C it. I waited for a bit more than 5 minutes. No 
> disk I/O to the logical volume.
>
> Self-compiled bcachefs-tools from 1.25.2 tag (displays version 1.25.1 
> still) on self-compiled kernel 6.14.6 on Devuan Ceres. bcachefs-tools with 
> tiny patch to Makefile to recognize eudev for determining udev directory.
>
> Best,

Can you retest on 6.15-rc? I didn't try that on 6.14, but on 6.15 it is
working for me (tm).

/Malte

