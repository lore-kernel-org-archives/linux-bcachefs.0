Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C216C605CF
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Mar 2024 11:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709723702; cv=none; b=RAJ9tBMBgYWnHCWTetOj6U00R1GyAb5M6YGTXHTSBqJfEXi5JaPnX5Ji5uBwKNxdHUNId+elffDN3KsgoPZncJVgZc5aEW7KZ1ylZTpay/jkdfWLIeO6ID2c4uBTTKIaCHmDPq3g73HF6tZPcuaHd6h9WVKS9+Sz9ComQ2907lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709723702; c=relaxed/simple;
	bh=DY/aB3QBbKYvrG77b+XMS1N+k5UPy8BD75L0Znt4Drs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ez45f6TJpFMLidsIT67Mf8G2LJ0uTVzKx2ENuQxU3xnqAuB7DO/eMqbvogi85NoPay3lzB0FpBh0wOAgF73Q8e6uQvAKOF+hYqeocrAkKlMK6oDy7+bYv0XHF304eCjwJeBix2yUlKSkgCsYEYhdriOjR8w85KTAyQty+qFoQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eJr6Rl3o; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eJr6Rl3o"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d3ee1c9ea9so24999701fa.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Mar 2024 03:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1709723698; x=1710328498; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SM/GC/uJ68ovpy4Y5o8SQjIn36+s3s8O9klO37PA6oI=;
        b=eJr6Rl3o7FdvohDiQ5FYyqAI1Ua9B4GOyM4Ghim5V7/4J3zGth95JK1+Pm6jt+6DBY
         AvuCOkQjwj8fBsh889VTQgH8Vac+mE1TG5sPvXtkjtVVCOL9HcYcv6WB1L9IY1kwWFLU
         392FPbMob6NoNH04iDounv/0WtclY7udYi0ut1PL+zwZxBHwJdedipRIj2RHUnq+TLSB
         AyY1qfKMMZBG2UMlP4M0rJqm0BLiVIbRtHAREyxIh3FGO0AdUUQLtvnvrQzkzAHuYInl
         gqkMp0M2Qdj5PViiVQjVcUU8i1awlxD8w664RxpiVn2Wds3o8X06XNVkO3Hl7f88tTbm
         o9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709723698; x=1710328498;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SM/GC/uJ68ovpy4Y5o8SQjIn36+s3s8O9klO37PA6oI=;
        b=tXXPcIKpwDS/DREds7r4u70GKCKl/61aE9hjuqgLkTx6NSSzMkqUAK8X7JzsihSnXn
         ev4OaPla8QChHuz8nqEIQGx2myQI9v8Hrv5agD9ZUCTsgmofvnddaQRsyINo6dd6D727
         B7ssEZMfQu7SLSGkTnhi1rCp1/eF4O3y7UQnkEL//0AgXmPtgwYBCOaPldcRs5wcqpMo
         +ArJJDc1RalTTtL7SAF9Z7wM4g2Cvx/IPSgoYv2GODn72pKP/a60q8aKq8DWmULsvHBQ
         r0rlDKNZO5/TjeT1lWePD/Q+9Gzg3TRI3UQ6NJhH2DoXQhoOph8DMvir1N3/xvY9LTgD
         VXcw==
X-Gm-Message-State: AOJu0Yz1lEjt2jEFv/xaldQZsetGR7Zj/0D9mCzDz7srVr0s8gZn5yb7
	JU8niDoahIy5Ru7n8To4YZCYUvX2duvAHW8FYZinO9xoxvAf3KPh1VNMEne+lydei9bFu6rsOel
	1DRcFNBScH4h6S1s5NgmZtiLDisuWBnYyng4=
X-Google-Smtp-Source: AGHT+IFHmFleMMqy/Iq0SqkqhU1GkHwx2Orc75ucpXsKUrTH17TwmPuzo0PXw7LRN+Ab7OZXmtVlYIsba/xo1Txu0dg=
X-Received: by 2002:a2e:b88a:0:b0:2d4:72c:3bb1 with SMTP id
 r10-20020a2eb88a000000b002d4072c3bb1mr12347ljp.44.1709723697822; Wed, 06 Mar
 2024 03:14:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Wed, 6 Mar 2024 11:14:45 +0000
Message-ID: <CAMU1PDhRCpqsie5G4jOdVsyOmaXa4naDjWFTvjm_RiDrAhwPRw@mail.gmail.com>
Subject: Re: [WIP] bcachefs fs usage update
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 2024-03-02 04:14, Kent Overstreet wrote:
> I'm currently updating the 'bcachefs fs usage' command for the disk
> accounting rewrite, and looking for suggestions on any improements we
> could make - ways to present the output that would be clearer and more
> useful, possibly ideas on on new things to count...

[Sorry for any email thread butchering.  I've only just subscribed to
the list and seen this in the archive.]

Background:
I'm working on adding some level of support for bcachefs into GParted.
It wants to be able to report the FS usage (per device) of a file system
to (1) display in the UI, and (2) to limit how small it allows a
partition to be shrunk.  (I understand that bcachefs doesn't currently
support shrinking devices).

What I would like from bcache fs usage is:
1. To be able to get free and capacity figures for a device in an
   unmounted bcachefs file system.
   EG:
   bcachefs fs usage /dev/$PTN
2. To continue to be able to get free and capacity figures in bytes.
   Using a command line switch is okay.

Thanks,
Mike
