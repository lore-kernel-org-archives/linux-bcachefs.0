Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92042208994;
	Wed, 20 Aug 2025 02:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755656965; cv=none; b=iSdI9fWdFnKTJgIjREfdwvm5zzp7QpJn5HRFnDISLXNabUa8qQ1v/BViUuAB36vY9rAH4+1fJ//OFrHBNPhHQWP3wTvywGXRYt5SQB89UVY4czJMeC0vK2dNHbeg6CyxBlZJNhWJRaxLDrk+qwnqyoi0YMJEpHAMr0Jw1StQ5gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755656965; c=relaxed/simple;
	bh=aJRROA13nBsl/fW8F6Cm+xwkO5ZrBlquogSmx5iMQoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOPs1h6fIQR0NQEcxicCpYaKi5E8Pizm+Nbc5sM+FfcVft7Edvojo3MuESKZxqGgiW4KALbhleij0Dre/tS6owe5tH900aqPGU4aML1e4ANHEbW2fIOaNQWnnPStRFW0I94nUJ2iF3ClVvv4fvifQsnlFPIKLjKhEXfCRNZ4q4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVGc4su3; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVGc4su3"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-323266b2368so3918249a91.0;
        Tue, 19 Aug 2025 19:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755656964; x=1756261764; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aJRROA13nBsl/fW8F6Cm+xwkO5ZrBlquogSmx5iMQoY=;
        b=AVGc4su3+0f1bVgXhMiNULaGu9CrCZ6CnMFlH9IoWEu/Kx4H7uSCbeSd1NfKfwUnuE
         qzvRoate71cW/HXlWj0aqie3SOIzG+PBnD1MwIwVrPURuPkD+3qATKIi+1tWQ6KmgT+1
         wNV9ssIlcOCNWkzutUu0wzmxakL4YMUcstZAmfI9xsxiGEoDnOA+wDewCEW4x1iTFr56
         yHZEDFZgY9xYjavTIercVppLEC5FTdfpIccaaQcfAN4gD3H8A/TYLtEFRJ/gwht9pEKS
         /6iNVGmfPYkFnepAxF0gkPjBE44xVRGpSVIGwj7qmWuYWfgeb7olgIqB7WNB7tsVi6Ed
         jWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755656964; x=1756261764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aJRROA13nBsl/fW8F6Cm+xwkO5ZrBlquogSmx5iMQoY=;
        b=HK8ts5JtgTVUd0moAyzvchYcJcuoBrNx9bgThzUtFYMO8vb9KLHyQf4DSkOgrqHa9n
         RQeK5G8Dk29DxONFSruvy++jG6mwK8K4gG/ksnN8HCbYWMj2GwS/iFU4bmvgnrR3zc45
         kOkRi8IGm8RS0JKKBB0LknAdZtVvPuaJGUqTlAGaiqczdun99/jwIGdX6HrKEoBbiIXn
         DgIHuIktHtoKrtUakKGBdi2f11Obny1sqOKskWC96VDX/vbO4Y3fiqLiWHJzTEl6hzIf
         L0HiL6g3OXO6q3EHsqSLqe9H7NUQyZ/8oAmwgpVseByAU4OdDGMpTRHtfeLqmd0w3DnJ
         ZD5w==
X-Forwarded-Encrypted: i=1; AJvYcCW0KVNpqVl857o38r8EuxePvvMCmtWB3PLKY98KqSLMhE1BK2pi2TQh04F+Pui2kkUldnTdIIlAKdhHYdI/5g==@vger.kernel.org, AJvYcCX+tiDIdAzLLKHEZ+ge0JA0+d9jI9A2O0gZKLqhNxZrXcb9jgMWpjquCspWeVdkyCFhuThhDcumoZA3@vger.kernel.org
X-Gm-Message-State: AOJu0YyR4hY4JRFOBkHuWJ97fE2yg29jCD0K6jsiDHeKljuG1DxTqoNL
	QMHczGYLqj01JJyq/+iMeTJpdvF9qWHNjOFW8snyFrIhrnDoLeC/t0nT6OLtx2Fa
X-Gm-Gg: ASbGnctJyGr6Zre+LjKVsw3ECZVtEnwgV7AEaxMhWwuD/lkj5BTLL/rCWFD3zihQhwu
	4dySdy+5wTCAXpYHFNqSolJJ2+eCbjPWfxtg6eriat+GYGaH/MuT3vSnjNpZZ0cs0C8uZzICwed
	Zh0gqaJWo0mJt5s+SUxg57W2h3GutYBzKI5fwxVSjd7q0Pu7Z4ab3zey1MfSN1vk3z80+A9ti8q
	SiWWtc2NxyJHYtNpqmI19IOJZ7GgsHcTCbcDjMJ/kZY9q7SOgzoZ8Pv5vmwyN//iCkcpNiawLOJ
	g13yUvGg4SFk51mVolvoCanPkrKH2ix02oPbWKzrXxwuDeHpg6A4LiOYO8fTTKYxetjdSvKU9VU
	qRwnKNFHI4iX9BOHdnz7spg==
X-Google-Smtp-Source: AGHT+IGs9QlJ2u15Fga73mda/GvbcK0vGaREmwa5VFajt0TeqJ9mX6ajFysMVTKHp9KZoIzDmPtBOw==
X-Received: by 2002:a17:90b:562c:b0:313:b1a:3939 with SMTP id 98e67ed59e1d1-324e133bc3cmr1918623a91.15.1755656963613;
        Tue, 19 Aug 2025 19:29:23 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2682004sm587978a91.27.2025.08.19.19.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 19:29:22 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 1F6C2423F8CD; Wed, 20 Aug 2025 09:29:20 +0700 (WIB)
Date: Wed, 20 Aug 2025 09:29:19 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: bcachefs: Add explicit title for idle
 work design doc
Message-ID: <aKUy_1IYtlKtLEbK@archie.me>
References: <20250820002218.11547-1-bagasdotme@gmail.com>
 <p7ocizi2jg36uvk64yy5mv5bzg3dyrvnosz5mhj5j373tzr7iz@txx5juyvhwzf>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tl/Y5mCJgHfBVfcA"
Content-Disposition: inline
In-Reply-To: <p7ocizi2jg36uvk64yy5mv5bzg3dyrvnosz5mhj5j373tzr7iz@txx5juyvhwzf>


--tl/Y5mCJgHfBVfcA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 09:08:22PM -0400, Kent Overstreet wrote:
> > -Idle/background work classes design doc:
> > +Idle/background work classes desiderata
>=20
> .....
> what's going on with that spelling?

I'm just suggesting a better title, though. Should I keep it or revert back
to design doc?

Confused...

--=20
An old man doll... just what I always wanted! - Clara

--tl/Y5mCJgHfBVfcA
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaKUy+wAKCRD2uYlJVVFO
o/h2AQDL2jWFSEuEL8mJaUdS9Oc7dLrxJ2b1c7bmMueaTbrjXwD/UH/VOYNhShRE
rUp31kiAmQXgL1PdIb4cHDg7FRZ9ogA=
=RwFc
-----END PGP SIGNATURE-----

--tl/Y5mCJgHfBVfcA--
