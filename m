Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E891877;
	Thu, 12 Sep 2024 00:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726100250; cv=none; b=tgQwUvvzZRGx4IVtybpoIMIv04kHdshSiiP9w0Ne7cwWPulQcosKu2imvhkHrivV67NhzZASWCfB6tSf1xv9tHZ6AUxHhbLP8PxgEY6pZ3m7DdACkKZqn1GngEu1a5RUsJ59KupaVYoadcVdairESunSyZidK6bjN+RCZLkpdRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726100250; c=relaxed/simple;
	bh=YZHMhqK6IvNbneE7mkJUhxiiA4ltQmGRXyb2p52vTZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqzwqfllCV9IIKNGX6k/f6mPvgu8Snd10QfOfKL1L6i2+045qgEN59FkW7Psue1jOYVT+COCXbeTHEtjpBCsmLTZPINwgfrjBGaXDfc33jzaneQ/2uJcdDMQU2C2Axv9LNU874eBWiGuk5wuVAGbfzPPnn8Lzvqp9Nfayypd04U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eqTCxzI5; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eqTCxzI5"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-49be785fa29so740904137.1;
        Wed, 11 Sep 2024 17:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726100248; x=1726705048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZHMhqK6IvNbneE7mkJUhxiiA4ltQmGRXyb2p52vTZs=;
        b=eqTCxzI5LxOD/E3kRqKWOw8544DWygBajRLOCOb5Onu6nvCfYhUUZJU57Y9QE1tSeV
         j7NtbiiQHrhc89DrDFYsn0msw/7MHF4H+L3rdRLu+pAgdoyS0Qs612GGy6bZEsk2UFPH
         V+M1/pLqQtvbc+ZxE7ffjRt9zCaKOsCq8mQUFkHf/QLWpT0sUlF5zxt9V2u26FHhnEyu
         UH8n+Sjz2PYeXabAwdI0Khd4nfiP3S1uJ80G2KxISWvxF49N23utyV9KNM4Gnv/M2t6O
         Rg7+lY12Vk8IIgWzu6UR/P5FSZL76eZVGCCnqul7FI6+p4izTQqrHwfflwIOiD1MUZfr
         um7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726100248; x=1726705048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZHMhqK6IvNbneE7mkJUhxiiA4ltQmGRXyb2p52vTZs=;
        b=wWFCjXOA/RdEmgWv9HN9u3MKD3CzSLjciqevgQWT+4AAb7jdzhtQt9QvOJgwR01ZEx
         nv4gF/I8pwluVr4KkMfX6LDbh1OM0/6QpkpCkZlBMrwQMYuKM7igqCQyr43CA+GMpCsm
         iIzkra/WSRybhEEda4tpvNmaozfOkTdk9eGDrI6fU3CnQ7SWbuDZgsLkQx21kEL1D2af
         l5OzhmU3E/sqmdQDyrN84GLXvZ8hMYfsFqNVZTjoYBdZRAXwo25VDQZ/6OdlXRMKufhG
         vc0Pc7sRNn/adDtaA3iTdDsArpxH5ti/NZc6IFgC0g3rI4zZ03j+5Q69wJ7FPvcrZTah
         XJaw==
X-Forwarded-Encrypted: i=1; AJvYcCW/yB6ZRiiNQSOT4fOsr7/iVuLr/Qxk3B3NYWFzYph4wvTe/ywxFmhm8HVM0SQCwicnu3CXjJBsXHVj@vger.kernel.org, AJvYcCWyqAk7Kqsm46ucZQTwWDJrIS9O2zl1Q4U7eOnodYvscRVZBVCfdwA76L8rnto/fGi6140UmaXu4hggvORKdA==@vger.kernel.org, AJvYcCXq3DlUE+am2TktOdaJgL6RcRs2quHGkJAyAeIYSHN4zITKGlhQX0pxCqhr8g8YcfYNVMu91pLlQA8rl/Eu@vger.kernel.org
X-Gm-Message-State: AOJu0YxZgxDSAa/sux5gTTFeSA13eghi6LWl2BveM+qEZIu7rRqdPDA+
	hIF3FzUXc/KhYEMqb3imXTIV4gtjWMnRIIaBppM0vTWoNHNGwh3lu/a+4d0coCNVnSsKTj9vkUC
	TRuCNeeqpVjHV7e+2XwBiYk0DP8zr8pJ3
X-Google-Smtp-Source: AGHT+IEkh27HxdqVER7tRynhKIYr3KL/M1tG+CpPDUb6YOmsaK/NZ+iJaz5OLyB1yhoOkN3XQOsXgEpR3NTbHxQ2ZHI=
X-Received: by 2002:a05:6102:32cd:b0:498:cbd8:286 with SMTP id
 ada2fe7eead31-49d4213d904mr860202137.3.1726100247709; Wed, 11 Sep 2024
 17:17:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240906195720.40315-1-dennis.lamerice@gmail.com> <200ce66b-845f-4f20-8838-619646f5f44d@gmail.com>
In-Reply-To: <200ce66b-845f-4f20-8838-619646f5f44d@gmail.com>
From: Dennis Lam <dennis.lamerice@gmail.com>
Date: Wed, 11 Sep 2024 20:17:16 -0400
Message-ID: <CAGZfcd=MZbt94__wek3v5e5DUfLZbgZ2uyw6i+gRWRXXrbDX3A@mail.gmail.com>
Subject: Re: [PATCH] docs:fs:fixed some spelling mistakes in the bcachefs
 coding style page
To: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
Cc: kent.overstreet@linux.dev, corbet@lwn.net, linux-bcachefs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 4:03=E2=80=AFPM Carlos Bilbao
<carlos.bilbao.osdev@gmail.com> wrote:
>
> Hello,
>
> On 9/6/24 14:57, Dennis Lam wrote:
> > ---
>
>
> Change the subject, it needs spaces to be readable:
>
> "docs: fs: fixed spelling mistakes [...]"
>
> Also, you need a body in the commit which includes an explanation of what
> the patch does (even if it is almost the same as the Subject) and your
> signature. See: https://docs.kernel.org/process/submitting-patches.html
>

Thanks for the response, I'll be sure to send a new better formatted patch.

Dennis
