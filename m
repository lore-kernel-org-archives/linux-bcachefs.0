Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482038F5A
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Mar 2024 05:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710135036; cv=none; b=kerDtTJletcTavjiVnGmK4b4RgZnI2xuDnFS7sH8HBuStQ1VsvZwbAoeq7Ty52MaS33nPVWzQsPZw+AI34R1aAqaPl2JZDV7GTNUep4ujSMhmIixmm7/9fb2TdHhvjaQz3pPf3BGrjakyB82Lnn+83NsmEaSR9b0klas712DReg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710135036; c=relaxed/simple;
	bh=QSULCMgM4RBYyGQMMGu8HEaWE6kxcqd/HD0+6A0t17I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bq+Em7OUOY9APxUbZFb/Bmzp0WnHtgJF3p6bB/JxmwN/IKlCr6/zPrHhyuzaxu0EyU3CGz3Zrk9mFKy/XUiFqJibrOA6sDlEarnBxrAau/xj3JANAUv4NHKXuaqteQFXZjyrdPukDlJXxHrHOtuX0EuJSqJzRjicBpAPt/QA/Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ZigxOb/w; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ZigxOb/w"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a45bb2a9c20so466393366b.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 10 Mar 2024 22:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1710135032; x=1710739832; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rizr8l7uC7l+AymItuBELPZGqhV97QKiNctOnrHH7eM=;
        b=ZigxOb/wYr7pH3fQe3EPwOBrgZ2shDNnr19MYFw85rRJ+0F+hHDarSBBwzClZQzqs6
         BuDrQ7gWA4nZybFg9jMExlYlhap2s9OTc/f7wWsfbtl41TKNYqpJuysgTEyVeRs5vww/
         QlZg419zeQfYE8j8QLPcDoPbn7vjdz8/L5IdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710135032; x=1710739832;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rizr8l7uC7l+AymItuBELPZGqhV97QKiNctOnrHH7eM=;
        b=jw1ZRZJQ763tW52hF2qquW5Va23mv8EVvLGVKO6TFsg3YwZ4eiIq7MCoMfrloAf2m6
         gBguOrtfcqlKz143fLuGneU5dRcjEW7m/NJUzYuLEAztKWEMl911hHMYoXB1MaULDr4O
         PDNmgxlDACNYkNdzXP7OBjo+OwMKILNnbOxGv7i3aeHTraYZx08uJENgl11/I6OgxdoA
         CHNJ4jtPPHpR+Q42jil72vPiGEliMPwDx/BnXRBuA5Ysvz76ZpBE3yPaZAZyveGgkyoP
         Wr+ZcxUmaCy2TK/Hv6MmVHAlIjxR25vxSpYESHLtc6Wez/N+tmjeNmyeNNJVQX9/WltO
         iBZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHIycPyN0Zzgu9ccxNoEYZGeeZxf+lEJiN47ZoJVUMDQ5DRHhdqyJnvMHY7OBtMYhCYIILpMfIOv+doplL7G3R2IZFmjLpwiCX+YNXSYI=
X-Gm-Message-State: AOJu0Yw+EIraGoVJToYUfn2LgYbWffhFd7jjdY+QjaUh+I0GwEdGrcs8
	jeeL5X3/xkisyaUneh8xqYDj3V2dY8f1ACOdnILDNZsFDcRkdT1gqllzBISQs26bAnFJR3VWQL2
	D403/4pyjT6pmwcF6Lto+XbP40Vw5Gk0UNQWZIA==
X-Google-Smtp-Source: AGHT+IEMzJDuggzv7sHUtfohuk8woRgSDOegoleOLiiwUp4QOgsp/WyrYcegRbxhUuQa31Ax6KbOGKsTOTJvi0UK244=
X-Received: by 2002:a17:906:1398:b0:a45:f5e1:1050 with SMTP id
 f24-20020a170906139800b00a45f5e11050mr3259326ejc.18.1710135032450; Sun, 10
 Mar 2024 22:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240308022914.196982-1-kent.overstreet@linux.dev>
 <CAEg-Je96OKs_LOXorNVj1a1=e+1f=-gw34v4VWNOmfKXc6PLSQ@mail.gmail.com>
 <i2oeask3rxxd5w4k7ikky6zddnr2qgflrmu52i7ah6n4e7va26@2qmghvmb732p>
 <CAEg-Je_URgYd6VJL5Pd=YDGQM=0T5tspfnTvgVTMG-Ec1fTt6g@mail.gmail.com>
 <2uk6u4w7dp4fnd3mrpoqybkiojgibjodgatrordacejlsxxmxz@wg5zymrst2td>
 <20240308165633.GO6184@frogsfrogsfrogs> <Ze5ppBOFpVm1jyb+@dread.disaster.area>
In-Reply-To: <Ze5ppBOFpVm1jyb+@dread.disaster.area>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 11 Mar 2024 06:30:21 +0100
Message-ID: <CAJfpeguu=DCvtU7dudXNncbxvy5joqS1Xp0Yf590UFPna6qZ2A@mail.gmail.com>
Subject: Re: [PATCH v2] statx: stx_subvol
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Neal Gompa <neal@gompa.dev>, linux-fsdevel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Christian Brauner <brauner@kernel.org>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Mar 2024 at 03:17, Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Mar 08, 2024 at 08:56:33AM -0800, Darrick J. Wong wrote:
> > Should the XFS data and rt volumes be reported with different stx_vol
> > values?
>
> No, because all the inodes are on the data volume and the same inode
> can have data on the data volume or the rt volume. i.e. "data on rt,
> truncate, clear rt, copy data back into data dev".  It's still the
> same inode, and may have exactly the same data, so why should change
> stx_vol and make it appear to userspace as being a different inode?

Because stx_vol must not be used by userspace to distinguish between
unique inodes.  To determine if two inodes are distinct within a
filesystem (which may have many volumes) it should query the file
handle and compare that.

If we'll have a filesystem that has a different stx_vol but the same
fh, all the better.

Thanks,
Miklos
