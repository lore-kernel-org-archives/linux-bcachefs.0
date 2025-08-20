Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CFB258ECA;
	Wed, 20 Aug 2025 03:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755659519; cv=none; b=TpZas3IqZzbW5Ct41kfUtd+ijvEI6T3lkgi2y9KaS2BecTbXRcUCsT2Qz3Eor4wITEDYRlj6DGvzEf8Z0vfXSmoEeEEJUd+zThKiQqRRXoUz+gIwhhIZLcgZxF4DAeZQm2qozCNp2sBEhD8Zqlw36eABTG6lan4IctXX6XP3FPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755659519; c=relaxed/simple;
	bh=46xGZNjG8EaGPJz9NcMXGPgRzezsUmAR9Xov6OuJmgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRAyFxk2+nBvS62Vvt6wQsrtJlraf/7tBjJVGDkObi/kdr6nyPpQUgicCxoEIL3xJJji/B1tuiucs2+wikzGTugz/BTOHu79jpKjGOKYLt9u67YMRTU+aczyCJLs5BE3JauRgq5dJ6e47+HVPYabQTvaoQ+h4i+hO+667xJPYps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WETQhtDt; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WETQhtDt"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e93370ab8so114206b3a.1;
        Tue, 19 Aug 2025 20:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755659517; x=1756264317; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=46xGZNjG8EaGPJz9NcMXGPgRzezsUmAR9Xov6OuJmgM=;
        b=WETQhtDtKev5napiU7z+TvxqSRpbEq727w2xA3U7GWe7oo8oMi2UtJfXDpBe4LZWvg
         RtWbDcA4MGPtIjJr3OKTk907z4Pk4yWShpAvexueNWovXq9gQKGKqMkkr+qL2o3nurra
         Ynbwnin7m27wXcOXnjyYBtvNtkcLCli7BfEQAbB1CtcQNWbB2twfhX2LqkAbB1pkNEPc
         Se6HqAmBy+6lg3zVXAGIQEXOlLLkHAUjSxxIWmdO9gF29MhV38DImdd6PfzvodEsd8l3
         skZLTb/PdBRr2kg+l0Cv7wvWzeQMhwGXLzNu6ONSb20oDzYPqRq8FCpocn8koq3ssZGr
         gZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755659517; x=1756264317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46xGZNjG8EaGPJz9NcMXGPgRzezsUmAR9Xov6OuJmgM=;
        b=MPMGVmuiJRnu/66vkfhYf+CkWKgdoR0hGSPVw9HOD9lrHYvTZMgbHBqbCtu8o232p5
         za5VsuojuSiRodsQopvvU6IDNqOwwyu/OC2wI5B/yTJxBG1+VewOvDPNb4SVyOnXEV2V
         NL4FjwfprKIawFE1J4VMZeWfcY+EuacnsrCrqNfVHLO7bhDW+KAHJTuZLqyFwgn8qFXo
         bUj/N6sR/QwoRoKVDQuOly7hju+8Vd+7CgFk1/VcFDz4GUIRDKf7OrDP7Z7ti2plFqKy
         MjOp9SDRq931bBCKCty1rHe5qI7u1CvgfJpiCCKAJ8bHGuRDTF3/Le4kqR5IUyotJMw2
         ZtIA==
X-Forwarded-Encrypted: i=1; AJvYcCWXqaurzr56P/wBrh9WUemH3IIuzvYPjQArRyYNdaqaGPHNguNTdwBCOD78zttplaR4l+Rig2kRVr071vfV1Q==@vger.kernel.org, AJvYcCXBOujDl5bMVomaN6TRtbzxI0IQXLfpI6Q0zl/bO2tqyERUE3wyGZfj/PvVsc3ZDVfYc5/SDeCHSkwj@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2oZxmhroFjdIRbsNHbz0kpyY7IuRU1vVl+4L+iahzXTetjbrX
	goz81XUEXwRYbI+TPGv66rx4TzJnYHSwbZN5+EAknVbBks5YSnZH67+F
X-Gm-Gg: ASbGncsaNeo57zcJAPGWaXTzT6D9dxkb5q/mHhB6W9ol0TlUFoQdW9ldTNy4NjSAFo3
	PtC/EhkL1ZH5nwdMVoSQm0v9InrpbGB902c6eyxxM6nUt+t0+fqZn4fTHycyVLd7Ws5tF1qho1U
	doxrgz0vNf3yHYJiptAFmZPNQcSFRJbqE8SEKKF2B7lL/rhWA17xa6hXsH5Kyzep8c1vI4g0NRa
	srl3aqghFkn/bVYuZ6mipvV/qO6RfEV7AvcA7b4UxHpc4w8CCCz3yNtYhY4hRUF3fdI5bQ8IHEb
	jk45BmgOgDs4jlVJmM5GyBFC14kT80aeghlWO6BM7zq2Vy+965tklNp8sOAZWPksAJUqlAUDf+l
	rADtj6aJSYoeO86UYGNB0zim9BzRvkjix
X-Google-Smtp-Source: AGHT+IGp2pdDUdCnk4NysV4+/7dFzbTqnFkq3Dgxp7DmrVANBzOwII7pqXGfh4whvuVRvz4CnS7QgQ==
X-Received: by 2002:a05:6a20:158b:b0:240:2371:d003 with SMTP id adf61e73a8af0-2431b92c4f8mr2303668637.28.1755659516990;
        Tue, 19 Aug 2025 20:11:56 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b47640b91a6sm965342a12.49.2025.08.19.20.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 20:11:56 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 07FDC423F8CD; Wed, 20 Aug 2025 10:11:52 +0700 (WIB)
Date: Wed, 20 Aug 2025 10:11:52 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: bcachefs: Add explicit title for idle
 work design doc
Message-ID: <aKU8-Bb1iIeYJTZQ@archie.me>
References: <20250820002218.11547-1-bagasdotme@gmail.com>
 <p7ocizi2jg36uvk64yy5mv5bzg3dyrvnosz5mhj5j373tzr7iz@txx5juyvhwzf>
 <aKUy_1IYtlKtLEbK@archie.me>
 <yyqgq3brwrstiaqydzv4ua5syesrg4gh7w4uhtwg3flhuxa4ji@7xciwgaluwux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8tdEDuhiKwPKhCWB"
Content-Disposition: inline
In-Reply-To: <yyqgq3brwrstiaqydzv4ua5syesrg4gh7w4uhtwg3flhuxa4ji@7xciwgaluwux>


--8tdEDuhiKwPKhCWB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 10:31:43PM -0400, Kent Overstreet wrote:
> On Wed, Aug 20, 2025 at 09:29:19AM +0700, Bagas Sanjaya wrote:
> > On Tue, Aug 19, 2025 at 09:08:22PM -0400, Kent Overstreet wrote:
> > > > -Idle/background work classes design doc:
> > > > +Idle/background work classes desiderata
> > >=20
> > > .....
> > > what's going on with that spelling?
> >=20
> > I'm just suggesting a better title, though. Should I keep it or revert =
back
> > to design doc?
>=20
> Revert back to design doc, please.
>=20
> (I genuinely had not seen that word before; usually prefer to keep
> things simple).

OK, thanks!

--=20
An old man doll... just what I always wanted! - Clara

--8tdEDuhiKwPKhCWB
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaKU88wAKCRD2uYlJVVFO
oyE1APsGEPC684fA9XtLC9UJesUUouHpdw2idaw5kcemFooD5AEA9UM/tRH1MY7v
t0fiuI7JdBV5mS689gNHTswGzJ0FMgw=
=Zpmb
-----END PGP SIGNATURE-----

--8tdEDuhiKwPKhCWB--
