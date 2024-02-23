Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32D21DA5B
	for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708731127; cv=none; b=VbYSY5laIZrc1ac+Ik1n8SYMz5YQfLTOsHqxZKLifeVgCPO+7YVgeLDt/HyCry2SNWUWhE50JWSVCVOqmaZuvlVUsv18pzm6Wz2OoPm/b79KEn5OUt3iApjurFbG14lMAqv64B3AIC9qs+N/wiKuespsUOU8IBeF4KbMD4Xy3hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708731127; c=relaxed/simple;
	bh=K7FHiqmUrv+7z45mFZz/y4LkzD6BMc+l7SAk5IuZYi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4FePDBBYvb9/m3Kelg6TUlO7EP6Fce3ktSKiDOmMeh99QdJBt1zk62Aw6TEf+loUEe1KwRe1CaOiRmG5uAvVRwTVaxpoZK80g4k5vNDOq1VUWKKNGIZAKsxWWhqLco6HXYbnzf/pnZaGUh8mBhzssNHltL234ltjcbhFM99wLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563bb51c36eso1088284a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 15:32:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708731124; x=1709335924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YE9A7jrj3x9gqZ3olg7A9pxtEnz5lKmlaLvYhGSJubk=;
        b=Bc5JAJ8+k/sUD5LB0m6eBcf24RWz/SHP0B6ofFAxULOxYlfStEbktLAfJjoY8XU/dF
         Kp8T+GpLCWuf2ntexj8MSyqlqRkBjGtcuJC/ORshNW9sTXlAstlPk1UcmGUt6ktNdpv8
         9aehjnx5ounx0nHxULPOZQNJlMn8l9rND1LzY3yGX3QqaKwMTK6xQ3EBvXWBKGeXV1sZ
         ASxzlDraYDyjxpfiEDBV1mtbv5iPXfu5QMWJJOHhsh/qnvkGK+Vl7Auj22rE21s1+C6w
         Ty2wajxi8mqZWBBpE2XPfNeZZMUaPbdde3e0+y/kaFOGSeVam92Ivu+EA9CWF0qn+iv7
         KLSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUR4jAnehH0QUsNEWAGVLWkLGMRsvVnpPB+2AGYPE6kqZbyKWUNatBEKzenW3dA6mhJprEI6/z9S00QYlLbx/dDTaaSlmT5bD0wzOC14Pc=
X-Gm-Message-State: AOJu0YwfSHraxffv7t2Osoa/m8L1c+8Rr10rtFJv3XFogwPhzF5oPgJT
	IwAsFLipBCSwGvYpDPzsEArLk3WkjoYTn7pUdyQcKPeIaSAI3912Zb3lsHj0B/U=
X-Google-Smtp-Source: AGHT+IHw/SQFVmkuodNfNjjwI7JsS0xphgXyzoayYNclzAOxyH3ayk1uA4+S8EKx1HJ3oAlecnT0jQ==
X-Received: by 2002:a05:6402:b07:b0:565:4f82:b260 with SMTP id bm7-20020a0564020b0700b005654f82b260mr671851edb.14.1708731123768;
        Fri, 23 Feb 2024 15:32:03 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id u13-20020a056402110d00b005653439cadcsm18914edv.25.2024.02.23.15.32.03
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 15:32:03 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a3ee69976c9so144737066b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 15:32:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVjBE8PM3A9ZAe6Z+ZtM6tql5psBbvQXL5fQruWg8ULwG+Jv7I51kM67vLAViSQLuUEqvXuiUSeyXPrhqLFpKXQwUOe2O1UEBujVb/X7VQ=
X-Received: by 2002:a17:906:b216:b0:a42:e644:872e with SMTP id
 p22-20020a170906b21600b00a42e644872emr93374ejz.17.1708731123249; Fri, 23 Feb
 2024 15:32:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223222042.140688-1-tahbertschinger@gmail.com>
In-Reply-To: <20240223222042.140688-1-tahbertschinger@gmail.com>
From: Neal Gompa <neal@gompa.dev>
Date: Fri, 23 Feb 2024 18:31:26 -0500
X-Gmail-Original-Message-ID: <CAEg-Je9AXSS7-62=UEbYt0_oAFPNK1yrXMv9dMn+njzNp8ioig@mail.gmail.com>
Message-ID: <CAEg-Je9AXSS7-62=UEbYt0_oAFPNK1yrXMv9dMn+njzNp8ioig@mail.gmail.com>
Subject: Re: [PATCH TOOLS] powerpc: use "long long" for 64-bit types in userspace
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	bfoster@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 5:21=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> This resolves build warnings and failures for architectures where the
> Linux userspace `asm/types.h` header defines 64-bit types (u64, s64) as
> `long` instead of `long long`.
>
> By defining `__SANE_USERSPACE_TYPES__`, these types are defined as
> `long long` instead.
>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  Makefile              | 1 +
>  include/linux/types.h | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 6e5d0e5..7363d5d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -42,6 +42,7 @@ CFLAGS+=3D-std=3Dgnu11 -O2 -g -MMD -Wall -fPIC         =
           \
>         -DNO_BCACHEFS_FS                                        \
>         -DNO_BCACHEFS_SYSFS                                     \
>         -DVERSION_STRING=3D'"$(VERSION)"'                         \
> +       -D__SANE_USERSPACE_TYPES__                              \
>         $(EXTRA_CFLAGS)
>
>  # Intenionally not doing the above to $(LDFLAGS) because we rely on
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 6ae97c4..004d5eb 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -10,7 +10,9 @@
>  #include <sys/types.h>
>  #include <linux/posix_types.h>
>
> +#ifndef __SANE_USERSPACE_TYPES__
>  #define __SANE_USERSPACE_TYPES__       /* For PPC64, to get LL64 types *=
/
> +#endif
>  #include <asm/types.h>
>
>  #include <linux/cache.h>
> --
> 2.43.0
>
>

This looks good, works, and fixes the build for Fedora on ppc64le.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
