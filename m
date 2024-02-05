Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8892800
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Feb 2024 00:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707094717; cv=none; b=OPZXaZqDwKKTyjuvEWH6xmiSeB3fq2aH0mMjCJ0IyKWMRtz2L4oNvSTvBLQ64EZBpWYRImJK1uIM4mUciZsXLYCHCfJEAPOfAfQ0XwSjehLYckWHy/3RIHJ+To+X4S4bekQeyWwRqh/ccjSCtMSbaEx50MI8DEXIfL1diLBNmrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707094717; c=relaxed/simple;
	bh=zMkNycScHYzE/zO4ulhkzPG5JZYjsNFh+Ei8X1TpSiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SMI1Tm4CddxHQK5SicDysbN4aC6s7uCUwuObALrLf1+iPYHQCD+8Brg2k15+Nq6H10vUVK8IFdipWqOdovL2Lef1A3RFYXXSa5oSdE3qdNFR+5lY4skwvhvwo81DJg30jnE6MyZLLvpOQEGlppU3OXzQ7+WnsAlpn+Nb6C1Zl8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=aMJuA+kO; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="aMJuA+kO"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-55fe4534e9bso3245364a12.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 04 Feb 2024 16:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707094714; x=1707699514; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zMkNycScHYzE/zO4ulhkzPG5JZYjsNFh+Ei8X1TpSiY=;
        b=aMJuA+kOuL8qGa3DOb947Y1ACTDg93SxqB8gTyN0JROuPraih/+lYftG9nOWYe9qQN
         8xiJuD3cYDOcWOdfz+qlASrttJ2shMzVVbP1ZxpsM0zRVUF+HQouN5ibTjlWZSpY6dJB
         oN0TPs2Wdkk5YjNtluP3hTjZNQlzYNwbFSDzYDrMjT/TCAWVIMtq4s84zSTY6xB06yU6
         V6SyiS6I7tqCnUZqVDSyFw/edLSMONr7QTSVM0WE9BN/hmX/s3WjoFGHsdPmwSX03v9h
         o4Lat914XzzwJAwQ5HTJ9tvAwT8Y7ex7ot0EkdGLkoPGxnYw34Dl5xPYY49atVkNU6+3
         l7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707094714; x=1707699514;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMkNycScHYzE/zO4ulhkzPG5JZYjsNFh+Ei8X1TpSiY=;
        b=EBBDj5xMuNHMBfOB4Ih7Oi67HRHpCyaF+J4fBNWZgqpt8hsLOy7RuecItYluymZaCW
         FfdR3GAEKzt/8t+M5JOxz0nxVepIq+VKhtEMEJvFEcyriSaUoiZT6QRXb9wBBvRMYEXr
         4n0AuIY3mImkebHnPj+WprUtfm/vjdIVZpOHsB05VvA7bfw6a5UBzuKcyDx+brnLjZR0
         SNvP9rVvOTZwFigNfPULUcZ5hnzG3v6EGnnB7tUl4+TiPjLxPj6awi+DQb+Ur6Z8kb/6
         QM2ekaXjuw0IvkaBZ0NZ9QAC5PQN6+FCpIhgm0qDDNDkWQULp3GXmmDkggJaJ7nct952
         2a5Q==
X-Gm-Message-State: AOJu0YxNZPd+IfPVSDaD7+IF7r0vksyI0Upchx3FABfzKo46PO551Vzf
	27ayfFA8168xoeSeAdbBWabz/Aro3pLnylB8UtRqZ2Bp8lX9NZIZI9qV9/gjGbBt8m+JjEDGL7r
	R
X-Google-Smtp-Source: AGHT+IH2ljBQEyoMSTKBrK7mkqzAGlf/piVd4Zqm8IBHnTLGb5nxs9sxOSIAKoefw1R4onvn+OF3+g==
X-Received: by 2002:a17:906:3bca:b0:a35:aa64:7348 with SMTP id v10-20020a1709063bca00b00a35aa647348mr5685610ejf.59.1707094713868;
        Sun, 04 Feb 2024 16:58:33 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWTCyJ/0FY6anw2f+m3y7WO3zYWmqDlQC9AOjMmNT8Ec1I+2sAtDsmsuJXKrZNHXz60hxbfTtW/H4vcwfA4rTk+8DfDDxZejywEj4E2/dY=
Received: from [10.10.3.174] ([94.107.206.26])
        by smtp.gmail.com with ESMTPSA id z22-20020a170906241600b00a31805b4165sm3732095eja.11.2024.02.04.16.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Feb 2024 16:58:33 -0800 (PST)
Message-ID: <55bbb92d-0d62-49c9-90de-b8955ade3cec@grsecurity.net>
Date: Mon, 5 Feb 2024 01:58:32 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: install fd later to avoid race with close
Content-Language: en-US, de-DE
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
References: <20240204075152.695920-1-minipli@grsecurity.net>
 <u2dylt3m7xymqtsgrqoqrbsbnmj5bgv3h6so35zwzgolazq22s@b3dk3zdesjuh>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <u2dylt3m7xymqtsgrqoqrbsbnmj5bgv3h6so35zwzgolazq22s@b3dk3zdesjuh>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wQ0d0qWZ4u7oOyYZofRZdy7K"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wQ0d0qWZ4u7oOyYZofRZdy7K
Content-Type: multipart/mixed; boundary="------------t7tcMMVYh5mkM9DG01I0rxEw";
 protected-headers="v1"
From: Mathias Krause <minipli@grsecurity.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Message-ID: <55bbb92d-0d62-49c9-90de-b8955ade3cec@grsecurity.net>
Subject: Re: [PATCH] bcachefs: install fd later to avoid race with close
References: <20240204075152.695920-1-minipli@grsecurity.net>
 <u2dylt3m7xymqtsgrqoqrbsbnmj5bgv3h6so35zwzgolazq22s@b3dk3zdesjuh>
In-Reply-To: <u2dylt3m7xymqtsgrqoqrbsbnmj5bgv3h6so35zwzgolazq22s@b3dk3zdesjuh>

--------------t7tcMMVYh5mkM9DG01I0rxEw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2/5/24 00:46, Kent Overstreet wrote:
> On Sun, Feb 04, 2024 at 08:51:52AM +0100, Mathias Krause wrote:
>> ]...]
>> Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
>=20
> The fixes line is wrong, but I'll take care of that - thanks!

No, it's not wrong. It's broken in the initial commit where this code
was still living in fs/bcachefs/chardev.c:bch2_ioctl_data(). Commit
96f37eabe7a5 ("bcachefs: factor out thread_with_file,
thread_with_stdio") only moved that code to where it is now, but it's
still wrong before that. So I used the earlier one.

Thanks,
Mathias

--------------t7tcMMVYh5mkM9DG01I0rxEw--

--------------wQ0d0qWZ4u7oOyYZofRZdy7K
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsD5BAABCAAjFiEEd7J359B9wKgGsB94J4hPxYYBGYYFAmXAMrgFAwAAAAAACgkQJ4hPxYYBGYbM
CQv9FIwjFf4zz90h+erR+wPR+Uip8QEw455JCVLFDFZDwfc+VU4EItUEXmMwhSaO+wqXtCROTwXE
QtJa0PylLP2iblhYDTaeRbmrXaHpOKgNotKaK9LtlJu2rnDOuJl8f8GRgK2zicEKphHeXRG2Vvw4
8aIi6HeTIgulzqnex4kSELJGittSoPap/go61vh7hfiDb1AaQpT5rLLguLb+u+KN203YT1NLramt
wgmADBsukcJz7RPlknAl6JRiGcn91B5iJgH4ww+5By0CORMonZGrxCIRhDuwqIT933m4oKHuGHt9
puA/U9Pttb17sHhhcYBKnJQZ0zqm5fr80pejimTj/rOFmxq96+E/p//OLNmXmini9sw8kcwn7b4p
QTKPjNpdd01Xi6R2BZ29etMs07xhxcEBmT+S4pTQYoZIY6isAvreoOXeZ0Vza6Q5WJ71bFpWuPvq
FrX3wD3Clf9WvglyGveEbhj9SKKAme+viJBFHmcmXs5yWeKLUmJs/4rboXKa
=nQuR
-----END PGP SIGNATURE-----

--------------wQ0d0qWZ4u7oOyYZofRZdy7K--
