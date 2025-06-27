Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F19199223
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jun 2025 03:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750994505; cv=none; b=uwypx8eYQFlFt8sApi0uKQ7y+8MnR4Ke7sUjPQ/9i9QnZhas7ciOlNIe5oMzA/TuJGfgG7Q8F2Ed9gbyH4LTOIiZFohgtqyM5mi0i56W/1WTWBdxw4drphLr9IbEzHN0VfmZEXdSdj+ci5WNFv1dn0zFEV3Wg3xAyyilFPnZWd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750994505; c=relaxed/simple;
	bh=he/hLvBnbigWw1PXd2xIzILnQ25Qspezkj3wSUZr1uw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ndWUM+wPTSQEtfKKeP7EGbWGOMXXqVsaavZrDnp6smLHitslXQU/VonJ5M1SNibNiBM3KhhLE9ph/mV0tRaqm7Aj5aJLVV8NL0EOdpzUn2IW6BD9yrGkF+MT7CNBJe5SXdIar8p3DQd5Nmkrcrk88UQG/eZisXw1zoxHIJIIHdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BLJbSaeW; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BLJbSaeW"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ae0d935020eso272885166b.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Jun 2025 20:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750994501; x=1751599301; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VTgFywLZhfkURPzWKiCPE+DZDgyApKxE5NQzTKN2sIc=;
        b=BLJbSaeW3X6x5WRfX0pmdrbsWlz4pKBDnEWkx27F+hQlEB4hFekgzwRFXkwj9AgS4D
         MKd9I/0BSpzZatEJxynujFumhibU79EQtY/qavpO32v8+09JHQpDE+6pm5hlg8y7HncD
         J7A0NJ/6UcGB3lP2xjIt733yCZhhpAIMVBxgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750994501; x=1751599301;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VTgFywLZhfkURPzWKiCPE+DZDgyApKxE5NQzTKN2sIc=;
        b=Mx4rCjYNpXdBzLnMT8zXdEAKpX89RNHUVo2UU7I34mxtnqt2ZjbbqI9+94c4GDcBW4
         iheeBba/YAc7AKJc2UcNUfyybcc1tyCRkDF5VPt698NNKNim79sIUhjyYa7QSFAT0K2i
         AxVjpGSYoyPoMbZO8ZwqOco+nOTzbGjZr/kr+NEHP2zCZlcXUG2/ddZlD5A3ihVxZcoP
         YyPuLjH/LBt+I7Ar37AEcv/vfV8MK2uOFFV9f9hI2xBSdQieoyCuK14t9Jh1xwHeEP0F
         DN5QkEiy4f0ekl83lziKeKmyi2d8wu/y1044EiTAoS/KxFsW96blmFFcPP3BfmFZb0kS
         F6Nw==
X-Gm-Message-State: AOJu0Yw2LUtF4mH8TAupa/d1v9WLNRu1I9M+NKlMzcSAKuSjLhqD2OOb
	5lkzKqYoKjCUfgrimpf4a/vj3J+iI5jF/WhWsDdjSaudrQN+Y4ws9hr7wmbZ3HNlT5aygiwKgnX
	AkoPgTY8=
X-Gm-Gg: ASbGncvbWutIKsaIzFKqWkhqPf6bDpqtqKp6sVtP0ZQbDX31hqmIZNFkZAgzFPPqD89
	SVv0+B2Xtk3dA55q3/ribx65h9E1+fbonfEbgUyLKCngdvKO2UminzDRzII4Avm2E+7EqQMrqKV
	xCR9jh06KNXksYVtfACtlMj7oP5Pumoy7bYdILEnD25z1d8FeW4NTJJ0kQkVe7QynO8BPCMJziA
	s99xnC3AEqI7+eUShgV8CzVWaCsjU6pnOP7DGcUO4y71D/UQespjgdED9BVkCXv8DQRrvSzXO3Z
	VajeM4WnQdWRkum6anW6KCxL7yi0GmNHcHHMdjNB57Z+OhPF9VjKA+PvfKiD/AneeUdgOGj27vH
	At2GRz61xSP6vAdQA8lawm+7cDawkd9oRzA70
X-Google-Smtp-Source: AGHT+IG0azaogEyXH15Qe30SHPCmLgppfdfiZdhR5W/4FC3fvUrNbRKlId5mgWdLkwOFTlSCHpYokQ==
X-Received: by 2002:a17:907:9605:b0:ae0:54b9:dc17 with SMTP id a640c23a62f3a-ae34fd2bd01mr124087666b.11.1750994501277;
        Thu, 26 Jun 2025 20:21:41 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c65ac7sm40370766b.119.2025.06.26.20.21.40
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jun 2025 20:21:40 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6099d89a19cso3176044a12.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Jun 2025 20:21:40 -0700 (PDT)
X-Received: by 2002:a05:6402:5297:b0:607:eda0:1697 with SMTP id
 4fb4d7f45d1cf-60c88b482a9mr1301078a12.10.1750994500083; Thu, 26 Jun 2025
 20:21:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>
In-Reply-To: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jun 2025 20:21:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi+k8E4kWR8c-nREP0+EA4D+=rz5j0Hdk3N6cWgfE03-Q@mail.gmail.com>
X-Gm-Features: Ac12FXxm4LeLk-R5TkNNlVw728828csptX0fmReoyGbOww62X28y2kGKkM02SZ0
Message-ID: <CAHk-=wi+k8E4kWR8c-nREP0+EA4D+=rz5j0Hdk3N6cWgfE03-Q@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kerenl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 26 Jun 2025 at 19:23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> per the maintainer thread discussion and precedent in xfs and btrfs
> for repair code in RCs, journal_rewind is again included

I have pulled this, but also as per that discussion, I think we'll be
parting ways in the 6.17 merge window.

You made it very clear that I can't even question any bug-fixes and I
should just pull anything and everything.

Honestly, at that point, I don't really feel comfortable being
involved at all, and the only thing we both seemed to really
fundamentally agree on in that discussion was "we're done".

              Linus
