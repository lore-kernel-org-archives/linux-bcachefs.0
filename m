Received: from mail.af.tnxip.de (mail.af.tnxip.de [212.53.203.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7A21DB346
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 08:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.53.203.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729325601; cv=none; b=eEr8CjZbQBJPcPf5241iHvVcgYM2ybB8sJQsyNIkJxyh1FKS6769JINFjdMhXu/MnEeYj90/nO/ewdffj9rE3+Ms0UI6UZGf/S9wUh+9RIEdnUqwkhqo5uuch8LVg4QaFYJzHf7Ux5DcOFfYZh+sb0NZUvsPd/D1RRlbgkLpe0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729325601; c=relaxed/simple;
	bh=YIXZ/qH/Cd6Up2w6/VurlTFXnGrl2zCZFenf/a0QYOw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=fFS/U41pe4CLyt8NK4tRWb2LoIsjBKgGpCnNUQmhQ21d8cMhq0zAwWJVeIag6uKupRjKGCM21G3+1YH2OoRYbXVPBCHvaMoSE/TkTaYwWm3fz4bM9S3mEKA53CR84Q0dpQZ9vLVzT9ImfIYhQ1LMC3RG00zymMjoueickDxFPEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=eh0qIpKK; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=1X3lWX/d; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=pDOdC6Sw; dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=vWh7xu88; arc=none smtp.client-ip=212.53.203.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="eh0qIpKK";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="1X3lWX/d";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="pDOdC6Sw";
	dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="vWh7xu88"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:4702:efdf:d329:a6a6])
	by mail.af.tnxip.de (Postfix) with ESMTPS id AE2ED20142;
	Sat, 19 Oct 2024 10:13:12 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1729325592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xelkt6w75RWxL7lXMPIT7aZi3RZ7nEcdCjaqy9pfuUU=;
	b=eh0qIpKKSIxKw0EDO1mFhHr3T8JdEUHUgWd7bIaZ6mtulY2xEeHYpwTFKbJkr88sUXpFuR
	N/h9hCdo2iqhm0AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1729325592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xelkt6w75RWxL7lXMPIT7aZi3RZ7nEcdCjaqy9pfuUU=;
	b=1X3lWX/dy1P/5krTVuoH9eUzmVdsR6u7fvAx43TwVH7AB8IDLs4Qvac0Bj027B3mCPPTms
	u1SaXUS8rOBwrCMtlvDXjbcWu8hRQEMW8ZOTRPA/OiGwO7072u3AxuvZ70g8kIPqQHlmrW
	3zl9AbzstqsMP28QeL0AddAqVDc1In4=
Received: from [IPV6:2a04:4540:8c01:1201:aaf4:79ae:6494:dd6d] (unknown [IPv6:2a04:4540:8c01:1201:aaf4:79ae:6494:dd6d])
	by gw.tnxip.de (Postfix) with ESMTPSA id 90F6B1021ACFB;
	Sat, 19 Oct 2024 10:13:12 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1729325592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xelkt6w75RWxL7lXMPIT7aZi3RZ7nEcdCjaqy9pfuUU=;
	b=pDOdC6SwgVfCQCfVe7sSLH/5WULO3o9R0lsUzj4W3u7JEsMyjCMSyk276B8pFBAFY+YzXN
	3Z8Qz0p/HBBEjbCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1729325592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xelkt6w75RWxL7lXMPIT7aZi3RZ7nEcdCjaqy9pfuUU=;
	b=vWh7xu88Wn4pcpyMp7mIVcF7JU1ZvuzwHXwdKmecOT1kgJX1Htf84qHQbWFLt2Vm3egmFK
	r5zXuIl8j6RouUMnmmik4J7bvPirX8jmfYl8Md3nW8YSDy/StO1YRYBbWJM8Txc2JqT6UZ
	T/QLtHOHmWoCzRppYdluQv7z0vZGV2M=
Message-ID: <1af6fd38-7ecf-451a-9be3-fa7b9447fa43@tnxip.de>
Date: Sat, 19 Oct 2024 10:13:08 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
Subject: Re: Another bcachefs version downgrade bug
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: Christopher Snowhill <chris@kode54.net>,
 "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
 <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
 <537913254.1059.1729273074517@mail.carlthompson.net>
 <od4yumygu66vn6hi2ptykbayrqeelqdciwvfrsbmthso7rzbqy@v4ba3bzceluw>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
Content-Language: de-DE, en-GB
In-Reply-To: <1249157619.1105.1729296906241@mail.carlthompson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/10/2024 02:15, Carl E. Thompson wrote:
> If you tell me you don't want me testing bcachefs anymore it won't hurt my feelings and I'll respect your wishes. There are plenty of quality filesystems for me to use where I'll have less hassle. But I'd suggest to you that pushing out testers who point out bugs and try to offer constructive criticism isn't the best way to make quality software.

I think in your case the developer of the fs is the wrong person to 
complain to. The issues you are reporting have looong been fixed but 
apparently your distro neglected to provide these fixes to its users. So 
if you are stuck with a 6.9 series kernel, well, bcachefs was really not 
ready for daily use back then. 6.11 is fine, 6.12 seems to fix the last 
issue I was seeing. So I think the options you have are: get a newer 
kernel and/or choose a different fs.


/Malte

