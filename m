Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740982AEE9;
	Wed,  2 Apr 2025 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611618; cv=none; b=Ea8CIJD5yvNSB2uqN8dKraMo2jP3K3U91BUzVuZmEmyB2c8jtschPQVF8NSl5YgYChmfygIeE/DKz6FcAm6PJPxpaIV/D2cy2MOUCbmMqWqrjMpcPz6l6OU3Lx7cMjGpNZVNV08eSlfubYaLX0d6FwS+3YgX1RdcyKLOZSKI4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611618; c=relaxed/simple;
	bh=a2xPLKRXNFM1k6b4pzJo6ujsadqfL0g/PuJfjy8Q/Ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYcpkeTKGLyjKfvfnMpgQlnlOtVAqY/9chTVn4UpQ05uGriqqpY13DBtbKDmnn9r66VfT0K+9W4qJezW8ph0Q2jLYuUVv5uLLrXKqI5Cf+a04bRQ6LOdZUh6CWJ2gdbO1Sr7D28GCEHU3IdwI+ZtcjRjiZ2QIrZ0mrEZnhu2MKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KerGOxvu; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KerGOxvu"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-af9a6b3da82so44936a12.0;
        Wed, 02 Apr 2025 09:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743611617; x=1744216417; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2xPLKRXNFM1k6b4pzJo6ujsadqfL0g/PuJfjy8Q/Ns=;
        b=KerGOxvu8yu9IE7dP8A2AE6rgiP+LNs0dVaL3WCJ+eOn5z24EM44eKBftgnFeNuRNd
         12/ttuoqQoaXgNuoo1gcUEQz8SRPIbEIN2NVrYausPCeLuAdGJkgGl8O97uWl/ljiYMs
         WC30Oeb3nbquvW1yvY4UbNhqfmQo3aNW0lE8HIWQK+5G0AGF9cAMsqEvedhbvMmW+xyd
         YMqMeFRv4U8Vmc+wECBG6YtyF+Oz/HFtnNAAuJKpxTXWa3WUzAoHlTsaoR32rrY6k0JP
         f0V1qKnUTrk6ef+TmW26pNQjOwjC0F/yooVmtWNd+b5n3ba14BSq2/Q2QtC76YLRPhM+
         gqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743611617; x=1744216417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a2xPLKRXNFM1k6b4pzJo6ujsadqfL0g/PuJfjy8Q/Ns=;
        b=USZfwvpX+WnFj5K9oATB2emoveahtRfkl4N7lhY+GGuDB4L20GgnGGqiKZwCk/G3R9
         n85lkislnn4KmR9WbXb+SHi8wPlSkyM1THq+QavNJSNnRf3yhuJ0zxTnPR7kfUHpJM2y
         uvoyHqvZwR5S64CZCa8xa7NoOxw/ndOuO1bT1luo4yhf7PN8DVUvdvmhKvFw4sF9T4si
         ialQ656na7ta8yn6T2tjXnMd4/A4MSAoWMba+PmQZtdT/txvc++K7fM7Toh5GWr/S+Wk
         ZMCQz0KJVvqiyUSHhlVParoffuHgxBkdTC5emIDuE7aKxwVT6oAAtr/iypFNHudpklIN
         kPEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQZ283G3cdZDCdXbHRpP/SFf98kW7Lo9wOy7Vh6NS1JmoEwwvUO2VuthYfCTI/czOFYtunqSFTiM647vg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi8DH17q9odKKGABrOnCIgFBNPyNdzGfIp1w7Z0BcXn1eW5PA9
	As+6zCx29i60/HNnuJIiHJBw6nvrioUreD4jXjF72x3X3/m4txcTaG2XbAmCeWiridQnuxYsRYF
	bZNoQroFk7LbsQaonnjrCWkAGbyE=
X-Gm-Gg: ASbGncv29Cm5vC+xwijOaTssWJnaHN/09yybMaRHQFeqUyfFRXU11vkJmLgb+81EiSK
	qQ5udEBEzP9uKKHRqjvZ/s6dIgHPymxIj2sekIzd58Kbt/8PPKDFfZx+9C4518ee+5vXHQPZ//6
	F+YNIpHydwzZ1NCNoXXgTpQtRl
X-Google-Smtp-Source: AGHT+IFePRuJ3j2s9IyQ0pR+vmX6gbN8OK9GvtH9S9o+IgM6Uwle22DNhWyjI1Qrq10lQblFq+VLC4SGdcaEN45RSJ4=
X-Received: by 2002:a17:90b:5750:b0:2ff:6bd0:ff26 with SMTP id
 98e67ed59e1d1-3056ef3aademr3578364a91.34.1743611616286; Wed, 02 Apr 2025
 09:33:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402161043.161795-1-bharadwaj.raju777@gmail.com> <zjqewsg6ijvol3x3rdjfyjeji3wy24nw45yb6mkqj7vwsk7mrn@yxnvgpj4i24k>
In-Reply-To: <zjqewsg6ijvol3x3rdjfyjeji3wy24nw45yb6mkqj7vwsk7mrn@yxnvgpj4i24k>
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Date: Wed, 2 Apr 2025 22:03:10 +0530
X-Gm-Features: AQ5f1JrBfyiPX15BceMt-IhDu2Xzz3EAQvGQEH515dfZf7zboOs61nV58pIlShw
Message-ID: <CAPZ5DTEGi8RXBMui823bwnt96PcqZSavH8AQ+LPhRs=sJ-Br1Q@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: don't call sleeping funcs when handling
 inconsistency errors
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 9:47=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Wed, Apr 02, 2025 at 09:40:40PM +0530, Bharadwaj Raju wrote:
> > In bch2_bkey_pick_read_device, we're in an RCU lock. So, we can't call
> > any potentially-sleeping functions. However, we call bch2_dev_rcu,
> > which calls bch2_fs_inconsistent in its error case. That then calls
> > bch2_prt_print on a non-atomic printbuf, as well as uses the blocking
> > variant of bch2_print_string_as_lines, both of which lead to calls to
> > potentially-sleeping functions, namely krealloc with GFP_KERNEL
> > and console_lock respectively.
> >
> > Give a nonzero atomic to the printbuf, and use the nonblocking variant
> > of bch2_print_string_as_lines.
>
> Sorry, beat you to it :)
>
> You also missed the one the syzbot report actually hit -
> bch2_inconsistent_error().

Oops, thank you.

If I'm not wrong, though, the bch2_print_string_as_lines
still needs to be changed to bch2_print_string_as_lines_nonblocking?

In my testing that also produces the same BUG warning.

Should I make a patch for that?
