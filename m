Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15151E834B
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Apr 2025 02:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745635653; cv=none; b=Z69uIIJrr0p2wDDDQkq3TvrbotAWa+p6965/XWYt5sRRxI4O5O82GTKeQs6stQo2lJTotB7QwTesc/2dobtJDe2G7hpTmPgwMEYOhuSW92Os3w5GY3RbCV1EayGmotX0fBuTe9jrIuQF0j4HX6HymT+xPObVJ1LO1tsGOqMB6nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745635653; c=relaxed/simple;
	bh=dEmOUfiZRIXIVolwLjkWI1ddw6yx/lDkW5uzEFubTfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QCYgrDXlh3oCB6NL3mwzn0ZKsisnMTdvBWYW1shCpwFY1AtN7e0IcCun735n9fpL6Pu2XwDz7Fzdpzxx9jKWr8y6WIOQqZhwgkogWw+ZbnSIyjbm3BRI4bRSwhiCTDnhC3DvksrO//tuDAYbH/Yz+kDovFJ1+bCYHJlUSmsHOyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R3/HZBhu; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R3/HZBhu"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso3811630a12.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 19:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745635649; x=1746240449; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d+Vis1nKLgTG0tNyn050nySpncZ/GwqyHhgeT6wraGk=;
        b=R3/HZBhuMYf39RRSJI415KOvjRp7P3vDgeNbGWAh6/NzePYMGioiDZiRSJnlO5YdST
         EXThTGAKKHd8X2vdVohzamvS9AXIeKfkqg1kGcE5tIPVX5Nlgd7hp8hhE4DpCyb4oPTz
         nn3yooHlt6cwIKzqFAI7js3GxkfW8+mw1TWww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745635649; x=1746240449;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d+Vis1nKLgTG0tNyn050nySpncZ/GwqyHhgeT6wraGk=;
        b=WvoLSJC3sdCkQF6QG+zjFWO9BDsg0lKik7QjKfsIj8DQSY6X1w8V4353k+RoeZDJ31
         zD8vVANtzixTNFhzte3rvg1bBIr0sXvDqNJwsyNX4U5cJ7D5ELIym9qeChBOT+5a8+/Z
         o3iOfhtGtyFd2JP1Mx1RNiWN8X/137SC71ywapGsbM6DLmdB6bmPvhoDSrtMnvgKcqlZ
         cpQktgoMTeYIWVhiWzAgmuduSAFgWJ4vSn7guU71fGJB10IY0RXJikXNdqACuc5D4CNI
         1a560guYb6MtHEWCHPbQjzA2JtJHf2a8j28J9juO90meAPzwu8yykr5rcV3pv/ts0FP9
         TppA==
X-Gm-Message-State: AOJu0Ywpf2lZfjNGOFJ0/MJYEBnFINJ+qJ/RLX7dgvYhQ34eE+Y/xbsb
	p1Q+cjPMYx4778tYJssW7e+QVNwWgp+ZSbJWYFwHX+LaqRPgtRnHAf4XLw/3IJG178YCUuxiP2p
	Jx9U=
X-Gm-Gg: ASbGncv9gg9iqiIGHeTevY/og3j8zITEuqsWcxbks7HBElW3KCc7yOBhg6pFmhneF/t
	fAIAaJ1EUWFanQm7zpKuubs9+t2S+JVjQMNKOq/SanlAXCwf8DhEU5iNx/dTL0GwPD6MTZ9R+yL
	agGH1JtTIVk86JPmNWkl+KAz0FDkmh1X6DmjWYDa5/y1LfbNw94/95GkpGZsqsjRsPFkIdtI+nt
	xuAKVZI28AvaCrhBPDnADfkCibZe8Io19SoNazpAK5144lJnJVOJ+6huYRrz7yblqB1srnKH1q7
	JDJLRk2Men3zRNke2C67Reb6T1blBavXGfxi2uvHPcgzfDV+r92jWfHMa385Ob1fBUNwzo1++fx
	lxjXmtwzjN1lSSbo=
X-Google-Smtp-Source: AGHT+IFQ13Cc++rZgVX75iUxPs+VrmrbzGTvVuG+QBqTwrSUi9cLD2HgZ5xB1s9uSKRJfCPW4IFFfQ==
X-Received: by 2002:a05:6402:270a:b0:5f4:d0c3:4dd with SMTP id 4fb4d7f45d1cf-5f7395966dfmr1091227a12.6.1745635649004;
        Fri, 25 Apr 2025 19:47:29 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7016f66b7sm2122678a12.46.2025.04.25.19.47.26
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 19:47:27 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ace333d5f7bso473040966b.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 19:47:26 -0700 (PDT)
X-Received: by 2002:a17:907:72ca:b0:ac8:197f:3ff6 with SMTP id
 a640c23a62f3a-ace8493ad90mr121410766b.28.1745635646503; Fri, 25 Apr 2025
 19:47:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com> <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
In-Reply-To: <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2025 19:47:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
X-Gm-Features: ATxdqUHnAFqikS6_GN0pI3h-AB6C0IvbAMYuZ-wE_sCeheyXsgajo17SdM6k4eQ
Message-ID: <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Apr 2025 at 18:38, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Fri, Apr 25, 2025 at 09:35:27AM -0700, Linus Torvalds wrote:
> >
> > The thing is, you absolutely cannot make the case-insensitive lookup
> > be the fast case.
>
> That's precisely what the dcache code does, and is the source of the
> problems.

I think you're confused, and don't know what you are talking about.
You'd better go learn how the dcache actually works.

            Linus
