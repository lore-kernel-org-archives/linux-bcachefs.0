Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D991F5834;
	Thu, 14 Nov 2024 07:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731570990; cv=none; b=i8e1hPf8ZmmLgPwNbkJBThpJrjr+ud9V4w/a2Q3arrnidD3FXVn50sOm+FvPmUU1vyXBdC4le0x7PimoOSwjOxtPnX+uwsmn1Qwi7aiYeVycnAsV9iMgf1IjtsqifF9r4vAhSMzlR7ZE8ac3M7mMhUpfg9sBxOcT8UsfHZ2TT90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731570990; c=relaxed/simple;
	bh=iMwt0nE50k8Tw7r//WAm+AfiZKrADzDAIkoZyYwV268=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=msBSpH42HFuq7A6b7VPfYPi9rRS4fV3du7FQtT5W19EpiGiB87yuprw/4hWnPngbWVFf0/LGuk5z3Is33qoSKPsrqZo2A5UYFY5m8qFgT7nYgq8EegXijuOHVMutjeCg/LmTtzbc3v6BRkxmProTtzr0xgL4Wts+m8d8CGSFvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWbyjXG1; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWbyjXG1"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-6ea50585bf2so3402387b3.3;
        Wed, 13 Nov 2024 23:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731570988; x=1732175788; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iMwt0nE50k8Tw7r//WAm+AfiZKrADzDAIkoZyYwV268=;
        b=EWbyjXG1xKz2JOWAwc6MXtbJurd8D2VzSBBzOwFb3WAbdqVyqPZLqe5wz4pW5jl/Qz
         3Sa7drePTGI+uGD8Pd1p9aPUO6w5wGxsEWkDZKUdAQfHN6Z9gR5AOC8DAIyU69IXVpv9
         HaUCGvuMuoMA33G3QdnOvMJA9VWQjAKc76/JpEXzKcbo5xmeVYe50V0JAGfkWIkOLqTp
         l3cEN6A/2E/YZgwWdiZYn0DaW0VsZWhwGUZn+jOiQ/GrqzRmBo/50EjWzkpSEt1nSwHh
         uLPUtE+QWJzGCrtPvYQzcbLYjxSCPiOO3ms6THR8D3SzUsgS/SbVFRhk11ynhXxHvxMJ
         99Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731570988; x=1732175788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMwt0nE50k8Tw7r//WAm+AfiZKrADzDAIkoZyYwV268=;
        b=SDQ3ACsTb6MQ15e43H83xTK4cuSPNc4OEubktyNVEA72bP0wWWfkh+b+SX1Yi8TVnz
         FPN9dOvJc0l0y8ZlHBT68RpPxBNS/vcQr3+L5pqzoCsr4OKe3564Q1G7G0f7zbnPFV2T
         j+g+lPFcTjZNtHaCR6xN16NOnj8ExQjuVLUKv3iWZau3k3ovuG1tC/pVrP9HRdEtb/DM
         0/lLDjesWWBSxnBq93BVm5RBxPeedAJj8wMyVv5E2XUJo8RwdLljIGbclfJcPWJqEWKI
         IUcfdTd7ltj3VYvsWuZCdl8eNOpYAHTUZOqv8XDUiqk9DdOORY7/1Nid6qd2Rx4Thqev
         JbcA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ0hXokLtbdfu2nhOkDlxPBjt/G3d7hILwU6K+3dG/PYTk2N+Yycz8h8n0FU4gw0wmsYo9SCJpwc5i59c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy07aBtTOCJLGcCrKd89cTDuhNWROkYoHhTfNrMzW2198X/Pg6e
	ezLbt+toFcgulll43B58zI8RgzJ7pGmOWsUdrguKNs5N3sMf2gP2G534aRgUPPOMENxdW6U/ElE
	jPnuWTKcq3dLIF7irrc7MQVdeqUdOwrFCOEImHQ==
X-Google-Smtp-Source: AGHT+IEO3lTiWYrFhJAYttu7a1fUdmcxqAqCXMr7SX2ER7LN2eFqMQ0BGzX2AeP26XYqhOrLTj5EFaLDFIbW2fY7DoM=
X-Received: by 2002:a05:690c:6a02:b0:6db:deb7:d693 with SMTP id
 00721157ae682-6ee43385dcamr12580697b3.22.1731570988481; Wed, 13 Nov 2024
 23:56:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241113074248.175133-1-danielyangkang@gmail.com> <tykjpjsmjnkdfm24thl5auw7m2x6wmopvwtefcpjamxyryiih3@guovfh2cqe5k>
In-Reply-To: <tykjpjsmjnkdfm24thl5auw7m2x6wmopvwtefcpjamxyryiih3@guovfh2cqe5k>
From: Daniel Yang <danielyangkang@gmail.com>
Date: Wed, 13 Nov 2024 23:55:32 -0800
Message-ID: <CAGiJo8Tx8-hHMDxtEByZyP-E1J+K7jrHCEKuzhdchTm0E8iwXA@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy with strscpy
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "open list:BCACHEFS" <linux-bcachefs@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 6:21=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> strncpy is correct here, we don't need the output to be nul terminated

If dest is not NULL terminated, then core API recommends using strtomem ins=
tead.
