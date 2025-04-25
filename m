Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C41211C
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 04:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745554878; cv=none; b=Anpl1L3xb9jpBmsBHvdbo6qK0uKfKql+F9w5/GhLzClw633V7BiQ3QbpXZtLVmbYnk27o/5OVwE3DFJ91IdwEYdmxyV36G/enqpGRljbxAnG8h/ZAEUjxwM9zjnx1gnwI5YqN3a0gGCLNoS+SUgJsV9K/gAWyWeHVzKlKx7AdAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745554878; c=relaxed/simple;
	bh=2ek74mNNFIgWcZk7Q8YaK5RG06y977D4eT9YNwdT+O0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J6lcbuejj/dCbls846YI1bgHwzvEdjLpbK34cQ9v5Nzd8yf8XnJVkWQJGFJN43i3O/fSvqLHDUo1m14hiCxy9uI7pAJvb0GY12jgPuZTa5EkS03ZDAcpGzHLOnnPRssO49nKyjyc6QqzbuoL/m/ZbEkTdKHwPTZc8kHsS7w5Lgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LrJsO8si; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LrJsO8si"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5f63ac6ef0fso1254514a12.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Apr 2025 21:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745554873; x=1746159673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6NAE0ezuMYS7J5WA+bsYijLDvptHGpv+uu1oCrM7N5E=;
        b=LrJsO8si6k0P5GyVYZqD4qp1dttAri8aygG9MdFDLjgvUHqWNphdxe+IGMa2sIvT0T
         y62JTCkL/wGMz2Ervlzqgq4A3Ku6mz+NEKkt43qv/lxXYQO4xebYZhAiW2tm9EAU9O2B
         Albl6SUSMdrlZB4cSpZTPBKJhiqPQgt2/16Yw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745554873; x=1746159673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6NAE0ezuMYS7J5WA+bsYijLDvptHGpv+uu1oCrM7N5E=;
        b=k9X413hm2PoTAARvLMcUMh7L0P0HrpXYxsJ2vtKWaiT2v7+ne+nBgeVkAYiqqWCsMJ
         cYI1fG9qF5eiEfMDPqkRPq6Pc65/WnkBD+Bllxkz83sfh+OlY2ZpoUSk0AB67BaZ9FiY
         lvVeu1ERvtYalSELe2PMvO56/W8YBNHK52+q0NTh3pvMXmmymdTvT9NHG4B585NTlfSg
         pTcSPu+pzBEmOESubNZQACmO0aTAnlKA0D5UlGnm7URkBA482AjQzIFdFJhTfTypYkg1
         D/GBt9/u/VBHZjyVHZtI9CyIzNSdV11PuPC+8OMXvWzAtoR9XcqG7mivOMSpJZE+jJi6
         7KEA==
X-Gm-Message-State: AOJu0Yyd626XvnUSwQec8gT0mNGAIeDn20Gvf6ICG0d210if8mGFHu+9
	FV8tUbAVq80UBhZqEGpjiKoMzfyqccIFc9aGtrl0Lf1MULuNvdz1OFQhchC488GClfPP0Ovgq1u
	NsFKUHA==
X-Gm-Gg: ASbGncuGlYFW9eR0pGuX3dl0CHmp3shyHSDEmWPkRvIoZQVTVLOLG8bMLZ3XUsQ3L+c
	7kWdLaHph9UFmS8CiXhob9Em2BD8YjYsLudGwfJIPC0Yaw16Ac7A1Ch+FYYCvB+3N2pzWIpRwSe
	HXZ76sNYhnw157qXn+U1uV80lGvHSkoloaZg7jBOs2O5cWvTA4gKmromO5n4Wr6NSJquWUaQoFO
	qkmRxc3vBRfMEKYVIZ7hBH2zLQ8dHd0lK2pSyPtL3ZhJG+48E7orrrv/G7UlFoepkNpF9WR7M8B
	bIcAiMmRaavcRGV2cLD8wV9pG9qmJoVQC14F2eF+PlP9XOqhcLPnxKp0ro0PJmzg+VT5mN7v8FH
	7xYCYNXcEcQQXhzI=
X-Google-Smtp-Source: AGHT+IGhrvqL7n5cL2NpkSz79xsCw3aEkhLkKkydNJg7McM7frwLtDZHdWfhnyBYTKc0NHMhiw3L5g==
X-Received: by 2002:a05:6402:27d0:b0:5f4:9015:a6d0 with SMTP id 4fb4d7f45d1cf-5f726753046mr510847a12.12.1745554873434;
        Thu, 24 Apr 2025 21:21:13 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7014007f2sm655276a12.32.2025.04.24.21.21.11
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 21:21:12 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac2aeada833so355150066b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Apr 2025 21:21:11 -0700 (PDT)
X-Received: by 2002:a17:907:94d2:b0:ac1:ecb0:ca98 with SMTP id
 a640c23a62f3a-ace5a48320dmr384453966b.26.1745554871324; Thu, 24 Apr 2025
 21:21:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
In-Reply-To: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Apr 2025 21:20:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
X-Gm-Features: ATxdqUGW6PrSoybEs-CBS2CL_qi9B6hsp2y203CCwxZ62Ilhm4qWIq-GEHNl9dI
Message-ID: <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Apr 2025 at 19:46, Kent Overstreet <kent.overstreet@linux.dev> w=
rote:
>
> There's a story behind the case insensitive directory fixes, and lessons
> to be learned.

No.

The only lesson to be learned is that filesystem people never learn.

Case-insensitive names are horribly wrong, and you shouldn't have done
them at all. The problem wasn't the lack of testing, the problem was
implementing it in the first place.

The problem is then compounded by "trying to do it right", and in the
process doing it horrible wrong indeed, because "right" doesn't exist,
but trying to will make random bytes have very magical meaning.

And btw, the tests are all completely broken anyway. Last I saw, they
didn't actually test for all the really interesting cases - the ones
that cause security issues in user land.

Security issues like "user space checked that the filename didn't
match some security-sensitive pattern". And then the shit-for-brains
filesystem ends up matching that pattern *anyway*, because the people
who do case insensitivity *INVARIABLY* do things like ignore
non-printing characters, so now "case insensitive" also means
"insensitive to other things too".

For examples of this, see commits

  5c26d2f1d3f5 ("unicode: Don't special case ignorable code points")

and

  231825b2e1ff ("Revert "unicode: Don't special case ignorable code points"=
")

and cry.

Hint: =E2=9D=A4 and =E2=9D=A4=EF=B8=8F are two unicode characters that diff=
er only in
ignorable code points. And guess what? The cray-cray incompetent
people who want those two to compare the same will then also have
other random - and perhaps security-sensitive - files compare the
same, just because they have ignorable code points in them.

So now every single user mode program that checks that they don't
touch special paths is basically open to being fooled into doing
things they explicitly checked they shouldn't be doing. And no, that
isn't something unusual or odd. *Lots* of programs do exactly that.

Dammit. Case sensitivity is a BUG. The fact that filesystem people
*still* think it's a feature, I cannot understand. It's like they
revere the old FAT filesystem _so_ much that they have to recreate it
- badly.

              Linus
