Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DE53921F6
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 Oct 2026 20:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791146491; cv=pass; b=IRH9/dtFyk+RBfmyS2fIDcrVULmAgOTmf7+P9jHqc+dyDg2PJ79P+T/diIYfmXjoUBmAhjfkR+zh9frXG/ukkjhwOLB+sAloR0BojXfEayZvHD5dFivZttycWxE09lSMgnDmFpsh/NREZDIBX+DR7x2ZeWjNWr5kYU5hFbgLRBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791146491; c=relaxed/simple;
	bh=DYgIValD9Alvft/I/FaVqr0WQC1Z3cMyBOukBzEpDIo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=VAdssclqLjI0CgvAHrcTrA+VTB4/fS7Q9jgPsE79/kapLl3TvllbbEBz/BiyoSj0uQ6wk3xLx86me18cWpzkAq9+W45O6BwfBRUVAdjLZbXcRKFOPCJWD2EQCsICVqbYGV6eqH2I38ispCqmyNwTLyJrWnGMVKKeTkXCT75xpl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mkdGfB0Q; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mkdGfB0Q"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-534e6545939so8615121cf.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 04 Oct 2026 13:41:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791146489; cv=none;
        d=google.com; s=arc-20260327;
        b=FyxsTkWMV5tUcqXss2ys7tKtDArUpUWY97x5alIjvAYoq2xdm1L2R3YOZ8tQgx+ydB
         8Q0jAD9X7We8ohKMfmMOyrMQHSl7wWL5c+9TALSsP/LQSKAMM+n0ttCP7x0/5SGuP4Po
         WEsughCfYxGZzMKCTp1QqMr2xPAh1CKDuiaVmDAvDV/WnqBKZsOHlqpl1KjtnY0NHJyk
         W6vnm2D3WvBofib2vzmV1JYB5wuyktfKTRqXGHtiJvvfChqJvAQcurqIxUZf3Li5GXMT
         HpB8RYMpud3taELF2rPVcIjPUjPERLMV9xLuJZlhN4kP4Aflg3dkB1J1cir+EfyGlSk/
         fwpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=DYgIValD9Alvft/I/FaVqr0WQC1Z3cMyBOukBzEpDIo=;
        fh=dVjhzuDTRrW+ZFMuuUq9DPxg77MTYd2iAXb5U85kmgI=;
        b=f4tkb34mxDfCxxrWadyamquLUsvd8n2F/v4aOR7S3vLwQAmqYzf17++r75+M3H/lRG
         qnQzx68HbsGkF5MfYHNTC9dEe3KCaZhdua4ovU7m4Xt6LA7VBzMmaniBMRaibsdbGrFA
         GP8C/9JO9h6kcQDSNH2GB98V9/rplfsLkn0RNQNF9MfRfCcvNyx+xiTJRxPqQIKpTcfa
         VtoShDuerrJe/CMd8AZOI9oW21LSSvpJuxKlm6Ciz9yr02tzDWVr7bZmgDghB+WkzL3v
         TqdYFYH1H3tZx+cDcjqSylqH4h+C5tZUkbNc0hXH4ekfPkKduMzSxBWisFur9KPtZsxl
         TOHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791146489; x=1791751289; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DYgIValD9Alvft/I/FaVqr0WQC1Z3cMyBOukBzEpDIo=;
        b=mkdGfB0QOQr645SQZeEbPd1Rx26EVirlMe2ai4gHHVcE7FieICtSovYrUn6IRxvDA8
         La8O7ehCWqhuW2N9oMbUOxxYiVbF4NRT6lCW1AzRumuQnNU84hQgMjpygPrxLgqmQGwW
         HjuRucWDIl72ElZYcVGfCmXW3/uJxfFll7oLirjG/zJR4aDvVV2984kl+NqnNDWkrg07
         dwjgR90/fDf7Yyx2nT1E4sxmBQrVN4KgVshQwz/9P1IKRAK84WR2f8BzYeY33OjGBMpA
         6s7eMDSsff9IyyJJr6Lmwfd5NSt6uC1VzwHWj6mL/X0O6fJGmmngpcMt41jk6n+JcHqH
         UBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791146489; x=1791751289;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DYgIValD9Alvft/I/FaVqr0WQC1Z3cMyBOukBzEpDIo=;
        b=17TslJ2+ZxWx6Dol+CI9hnwjAOG4tYG46gua6GcNB968TdZuXcOrOfgvDd+AZSHxoW
         3DxCLh0A4o2ionnfOgsL6Dt9XRihgViyFQPfexhYvDKjf/mfgB/4+srP0PchNr2AqalM
         TjS0qcmXkLzMsksB835EILWYqP0BxA5MHmM32tRIgKkoT2GYoUw24ly1wvvbB6/L+FwQ
         Pfm1pnV4jXtZ+uRcInj1SrIaGMQmaGsvwgNSVvFG+mVTQbCbLcXYwH9d0k97Fcf8ysdF
         QkMThFz8hfJ1gGbZN1wnyM1/BK0fQdh0RoCVOpvdqc4rIJoL6+NDf5HjNLvWYhbDcKmC
         qfoA==
X-Gm-Message-State: AFuF++m7860V/2JuDGmfnOiIMrtnKYR+tZQCuOlsV7tTC6yW+9JUh0wo
	G73vkl7qkPUF700AUlMy3AKQHnHwDsP3D8shBffbcHdiz5nvDCgJunW1e8gaOIk6rUUV/8JeB+d
	lXn7nv2E07hfoVT9nJGpoUyhHfbUi9mqulL+R
X-Gm-Gg: AYBFou1DhsmoPlFkzhuRzFnGPkRcAkZvZ0C4IRz5oQpbygj3vySxtnRm4vORKiUBNSs
	CzFdP08jAPo2MYKUR44gA+8FWCDy0PYQH37teBihQQ6hP5oCsQLT/Xwexy0EclBmMCEyqW3IVsT
	i/e46QDVgbA4WjxGQmflMX53NvL0CBBCGWN3Trcjt3v24ydmVOPzNIaM+h4v1OWGJt2B87XDUhV
	d007GqDGtjgINZJhu2iXEGvun5eVqUYFk6xohsD3jzu74SMTAwULqGLAfdQzFEDlLZTv2kV+oKG
	4WM55A8V0wzP+7fvX0IJ7A+8c1M7dw/I4mTzqoLiRePZm4XkAGUx
X-Received: by 2002:ac8:6909:0:b0:532:acb9:595d with SMTP id
 d75a77b69052e-53511b8e611mr99690401cf.8.1791146489593; Sun, 04 Oct 2026
 13:41:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: J B <jb.1234abcd@gmail.com>
Date: Sun, 4 Oct 2026 22:41:17 +0200
X-Gm-Features: AclHuK9F8Sx4mUf92yCXJgnNnb1mi5_s3JQkrMfSFFL3tZKrmAkrUXNJSYpAhiQ
Message-ID: <CAJXMFhEP3hBF=V8N+t6NLTY+WqCFDk1PHDMqR60Q-Jhy8hh+yQ@mail.gmail.com>
Subject: dkms-bcachefs-build rust error on ArchLinux
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,
now it is OK. Thanks.
jb
