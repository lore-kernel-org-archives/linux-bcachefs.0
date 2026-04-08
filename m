Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7032929B799
	for <linux-bcachefs@vger.kernel.org>; Wed,  8 Apr 2026 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775658308; cv=pass; b=ZCHq+tHllEHV1aAXW5sQOXGvMjhOBT7DJIzrXgA5YXTPsT5Dh/+vpgALuwiVIBRDcYY52Jzn2jSxqqr7cxdvEm2AfRA27waXIEe21DLynoHGsex0ON12QyWUWXBJI5O0tUPuOff89xqafxe9v6tGyNBKiOMF9BfG4oAh3BNt60c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775658308; c=relaxed/simple;
	bh=dLzy9ti4M3e5NUPv+BlhsOKia31b4pk6vxyOuwZGjDA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=OTgTY1HaqGaSvk1Qd5fJT2c60jciT053uUVSvU/BRnXgf1fgftQXHWPqJffDwTPbDf26BynTHSO0m9aeSgNFDm4ruQlxxWNYOOW60v7mfZYTQR7En9Q/NNXUx85qFbZhEdUnDUlqh3jZAKKnWRayS3W7sbZJgPrAkh9IPDUImMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nVXmB3/w; arc=pass smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVXmB3/w"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-46fb6d65c28so1679950b6e.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 08 Apr 2026 07:25:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775658306; cv=none;
        d=google.com; s=arc-20240605;
        b=EM0YSTLgzpOLFUGuQWfnBnuk5nYTTkNoQ/94FzlmVXXi/wx7XM+gpILluTNJd2bZab
         h/g18MUZp0PAjOt8kQehcQAI3QOV+pCFsjnb6dlc1CVzB5MkKpIgleBTH6xPH+G1feRD
         Y6ovm82lGW30+Nt2S+75mOrEy19MT89a7mV3M/oo5NvTd3pGMvbZpY98UyD7mXCID0kZ
         2ED0T1bGiLh5CLtMcAQL2nFUcC2r/YE3GHVw9KPdLwC64Zk5YWBecj/t2yrJXsmWCtem
         lCu7mRTBThLYczumxWr8fonI5xIbZeFLj9kGoeEeS6ik3j9uqQ9NPxX4YyoZXUlHix0Z
         Yi1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=dLzy9ti4M3e5NUPv+BlhsOKia31b4pk6vxyOuwZGjDA=;
        fh=dVjhzuDTRrW+ZFMuuUq9DPxg77MTYd2iAXb5U85kmgI=;
        b=XBhKVOWOozidRzxlJD5ylVBbLq7bqBI6+/mm01VV5bOsVND7ajybITHWRB6OBesoMq
         m2QPHQFfULl4cLd+G02xYEsqg80wBmI9zZUPa1Qy2wArjRnHLKYRDCxmS5QED0cUs5N1
         PPE4a7XnWzVm7qi6z5/xm3jt90CwVoVgJtXG9aCtbc1wGmp4YkvcMjVMixHi34XOZZ1+
         HfqVYfg1xIUhBM66flUtjLIEEg6Nww3evQq3/mGiX4MoEb9TIYXWK9qrroC04+6hpe1X
         kO4yuID/Gi4u2/ZF2+BguAbva3jL8dnANocI0BtYvNBcQrRfieDcAIcF0IXG9gOBOcMX
         o00A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775658306; x=1776263106; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dLzy9ti4M3e5NUPv+BlhsOKia31b4pk6vxyOuwZGjDA=;
        b=nVXmB3/w3SaLileNmtKHNsqg6Z6MhIKrY8b/3NjP9bt/LejmnXN3ni9aObJwbRPFzW
         UXOG6+hJeSfdQCnAZxANZWp/gEaAXWkN1daxLzxBdL2RwqDdeRw/1Z/LpSsCMX5TwK+B
         0L0rC9tlni5ObuX2jFTJepRIQazTvZZtbC6AJc6o/7FsUcIRGUV9afpmp1KmMIaMmLaK
         YTk4iRrc6rbcnGMGcO6CVG7FlLUDzYNG0UtPUwTdPra/2INCtdGhkksEI0Pys+utO5OX
         w1tNDCgM5GxfeqfhqBvQ4XjmTZ/Hq+oDz2N+tx8yEylD+WGruqBBnR62Y3llu7bofreZ
         j55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775658306; x=1776263106;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dLzy9ti4M3e5NUPv+BlhsOKia31b4pk6vxyOuwZGjDA=;
        b=i5pSCUzLsvtOhHoLNZidkHpwBHiIDk6+sVw5Nke8NIUpTVhS53kSXPsNuPS14KA34O
         OieaiEb6MCSf5vXIBBagQknbn806ioo2Fqe1bimfcj5E0041zMCDDHPLBv9gUqqQ5Ac6
         GIqk6WB4qFcHizfXgmN9WybHW9YRJH6+wMg60dVcT7h0ig7uw6rGy7lutFYFcVO0lvin
         A5AzFruUzXCTofVo9YGecCxGX3Qi1gRlTTxiNWXdkrYNON2wW/9L8r0oiJexhVHSLu1p
         qj4beAnaFe5GyaT+ItRqI7EdUsyqnTB4qiwRB33voJB93kg6P0nIR3nsfiZJFePnD78Z
         r9gg==
X-Gm-Message-State: AOJu0Ywd4cl4BOBIWHmX+bSRpO2WVALqpFAUnV7x+iGtXbwIod1EEDam
	r/sMB+U30HKCuHvOB99GfUOSKKFWwswWY/4GEZg2kNWKllwBMN3+wS/dgDXX7JQEed6nPXBni93
	XZw+CRxsJQSlwwTdwFZEtCI9AgEXswLTWR0qkVIE=
X-Gm-Gg: AeBDiesBb87i0kTs+1bGur6LF68x6RTiDPbczavNw+UwJnYRoKAqz6Rg2uXwYZJ0mIv
	NKCkvWTJ+QAi5jCeprzw10EqYxphRP85J1XPP9YTXIkG0EWn7gXRd7boevO72dshsK/St8Ym/ZQ
	XVkWtgsvAOjOJFcP4PU9ovSgHCFTZgRpR+SrK3VPgrjLhMTt9IigB7Wf5uOy3Vnz7HdnozQUssT
	waXLPRdjLFMtPdoqYqH1aaPQRjmicM+kMEfkb1FKLvyjdSctU38AZ42j6GEE+QuF+PjkfooMaUo
	hkg912zLQAawNOdE+g==
X-Received: by 2002:a05:6820:198c:b0:67d:f55b:a992 with SMTP id
 006d021491bc7-6822152ac2emr11676815eaf.46.1775658306152; Wed, 08 Apr 2026
 07:25:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Guerric Le Bihan <guerriclb@gmail.com>
Date: Wed, 8 Apr 2026 16:24:54 +0200
X-Gm-Features: AQROBzClQYX_4qCG2gdrjPPzOfSpYL5xlvTkoheLynwHe50y2fbk5HmregtwCIU
Message-ID: <CABuuC5=9vWDFQRwXFXfmcUh+CUYhN=g5j6XVuMPqjPhQXFBO=Q@mail.gmail.com>
Subject: Disapearance of .asc and readme files in apt.bcachefs.org
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

For information, it seems that the apt signing key is not in the apt
domain apt.bcachefs.org anymore, and so is the README that gave
information on how to dl bcachefs this way
I don't know if it was an error or if it was moved, if it's the later
I didn't find the new location

Thank you
