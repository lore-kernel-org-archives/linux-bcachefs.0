Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3261DB13A
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Jan 2026 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768681090; cv=none; b=fyuyKygN1lxt4MiF0T1yTCysttLgcRdRaiXcByzaz2wZkA0/iWXnjnTKMFzbTAB36uYMS4h4uRyu4OZHbS3t+eF+ZKciH8Zy1JF2Cm/QigpXuFVr0+N9Err1L/HElrd2WZgS5tziyzM+3Y+9cZWL/S6cmhNZfnLbCoaZmDCDqZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768681090; c=relaxed/simple;
	bh=SbALvYFjYQMmSVImQZJDUaUJeTMYtyvknj3Pnug+LZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qclBnRwYpRLvLWWIZ4mZzsftxqoHq8ye/DNqhbdaAtwnFGiwXLDsSYytrdZOhsga0fp8nfuGxciBwioGBxknE3o4vo2d5q8qpGjk3FLQJR5YyyTDLufFxtn4Q1CxNuFyOyEU8onc2QYGxAjlgW3VlCJuiEY2Cr5Scd1HuqXYk7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e/7XpDGD; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e/7XpDGD"
Date: Sat, 17 Jan 2026 15:17:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768681086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FI3RcpgX20xIr5ktYCiHuy+wbmrQ71Yu8ezU/UmLppU=;
	b=e/7XpDGDk4Y49wOncBP6B1C9ir+n0Wu32pBSiuKTgpEzFch+jt86yZtggVpaAuv9oLF/Yq
	iJX/DlVPy69PYfE+087991xXkrAmlsotndArwb0DKoTlvIA7RvGZH3/kXAqRz8M5TQ6Dgt
	lMOwqvKgmho1TZN0v13Gq0zJAUAUGDw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Engelhardt <ej@inai.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: `bcachefs fs usage` is missing some spaces
Message-ID: <aWvuCklhJsxxWymV@moria.home.lan>
References: <8sq99o96-0755-r095-o410-o6n1o4oq228s@vanv.qr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8sq99o96-0755-r095-o410-o6n1o4oq228s@vanv.qr>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 09, 2026 at 04:10:22PM +0100, Jan Engelhardt wrote:
> 
> Kernel component: 1.33.4
> Userspace component: 1.34.0 (also with 1.33.4)
> 
> ```
> # bcachefs fs usage /var/lib/lancache
> Filesystem: c5ac2bf7-79a9-484d-8886-5188cb3168e7
> Size:                  5549130619392
> Used:                  2488634602496
> Online reserved:           114860032
> 
> Data by durability desired and amount degraded:
>           undegraded
> 1x:    2467920244736
> 2x:      20597702656
> 
> Device label                   Device      State          Size      Used  Use%
> hdd.hdd0 (device 2):           sde         rw      10002030919687816089600 00%
> hdd.hdd1 (device 3):           sdf         rw      10002030919687816089600 00%
> ssd.ssd0 (device 0):           sdd         rw      96019572326463255844454465%
> ssd.ssd1 (device 1):           sda         rw      96019572326463252830208065%
> ssd.ssd2 (device 4):           sdh         rw      96019572326463251319603265%
> ssd.ssd3 (device 6):           sdb         rw      96019677184062093350912064%
> ```
> 
> There are some spaces missing in the output. It is not readable this way.
> 
> # blockdev --getsize64 /dev/sde: 1000204886016
> # blockdev --getsize64 /dev/sdb: 960197124096
> 
> So that's what the number should be close to.

There's an outstanding pull request I've been _really_ lazy about
reviewing - adds flexible tabstops:

https://github.com/koverstreet/bcachefs-tools/pull/488

Maybe I'll do that tomorrow.
