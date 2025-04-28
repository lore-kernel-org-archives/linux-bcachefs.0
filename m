Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F42CCDB
	for <linux-bcachefs@vger.kernel.org>; Mon, 28 Apr 2025 03:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745810208; cv=none; b=HovFmE7Ld++eXgy8QbnicndpvjDRtiB9C0v1OY7HT78RUg8OkQwjBZbQ7VOWYTEkW6t1oJoIQ8p83UNP7fzfwG0tvDY+IEE/U6UdorekQ3oYSNKa46CorKYLGbr3/wl68vfBz70d1gKa9/gLp7W/nO+c3kvyoNTjqU1O/9I1bhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745810208; c=relaxed/simple;
	bh=bo4XRnmv/C9CPBRc+eOmyFUi6OPxRNkntH1IlX/FEsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kE6eAJrc8AU9onG6klnlpy7JecBjGI+r7Tqz10Pcvt2Swu9G0i0UTOCiVUrWDYDI5jFXrZwaMdhdimeu/otRhUv9TfTeVymx4zRYkn49RZPotfgsHTmud+2OEygitBVJcb3J3hhchoIHM1K9wHHWSQqQQ4aLiSJsQiHUS4QtDbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SOKhoZ9Z; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SOKhoZ9Z"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5ed43460d6bso6010000a12.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 27 Apr 2025 20:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745810204; x=1746415004; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t0e7nP3hjcaqKwc01vRHOmUcHsrAvpBqvUnI+4uZsG0=;
        b=SOKhoZ9ZPC3h+pRDXmjykHK8riOpVX07v0/8r7zDhVh9GKPpVjkW9s3t0HZ51japCO
         UEqU/e96WxxlGZhgPg6/BrjECSyqZHYlYIjzCstWdubxZAUNvm4PUxIVH+Of21fOC0xf
         ypvz81b2ecTBlv3EOFkdpIXs3QFoANgLOOGvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745810204; x=1746415004;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t0e7nP3hjcaqKwc01vRHOmUcHsrAvpBqvUnI+4uZsG0=;
        b=f6AWKK6DXnlHmzZFB3nAs4A4sZdS0VXADbsTOqigvNI1LcvN76lhKnHr/pxg7fa9Gt
         bKqgjjDBU0NiyKHHirb1Z/bN+qKxItOL4+MCnYocK43CAfTSeFOG7SqKjiYMiqE+RNWR
         SIIP8cCnvAhGzWkOYDUZ31hNsXl/jdNhLBO/Na9j7j3APhEm+PQHlCiEhoLKa58JkUzq
         vah5pLd9US/GPN/98HlkcQf+KDSVZxoKYOD291fERa5GCrrNH396t22mcVS2Ivr/FEJw
         U0pNbvxj6rDzTVqWyKDmhs3A444dM4H2p2hkbvnuQArHpXsVgeHKWYbzARuHQoedcfEP
         sBpA==
X-Forwarded-Encrypted: i=1; AJvYcCXWDsaf2GvaAtdZqocpBqrXcssItL9n38JrRsZPaSjKi2jP8P3Y4pomp9ue85KBRK0ECfXkQZm4I7g94EdCJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXiGGbwm2H3laafrn1JGCNh5og5oO1DpT2MMIut41n0Swq54Xk
	V6fR6el1W0xN3PX0tpECiadCbaNArQqGUFNNbOoFaHbxVW0FXqGEyLfD5qcjoFyeoD1/P8s/0MM
	V7zE=
X-Gm-Gg: ASbGncu1PGvBvbW6Jub+whttmCnNtRdwGRscsqF3mtxAUCJhIX0PvVu0SQ/4b4pVZbr
	euLxQ9cnDJ6xyL8Ui2h7BgrjeU93ww1G9ZrRCDcQG8tkmuComobMoPj55BaRPiuGEZeVewBw4Ve
	MOMcS5+K6ZDYPIsqwjXN61z2kKKT9er33gePZdLYi90LS5rOko3W8wl9nKxxv9zv80Oe0P1fjsc
	TZ0A58Zq79ElWyJoN3kF8U8PKCibcHV5CwV/dhqPK4OUmRNUvsw5V3vXQgAwTE9CJ/AtxmoaYTy
	H8ARKIFNL8GtiUn8UdTNWWvcMtPI2WLUtPlQdaGxP/0B030QK7dhgcMG/xzRbayy6dzqTBX5LkP
	/9CvAv5/A1jAobYY=
X-Google-Smtp-Source: AGHT+IHGizIarGMsTp3LGeh2qDEEMRIMsCDwMuFKTCYW2hnnC6gDaxZypNkOJoMnw4l1/HrtSrp8uQ==
X-Received: by 2002:a05:6402:1e96:b0:5f6:c5e3:fa9b with SMTP id 4fb4d7f45d1cf-5f722673af0mr8019270a12.7.1745810204302;
        Sun, 27 Apr 2025 20:16:44 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7016f5acdsm5053398a12.38.2025.04.27.20.16.42
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Apr 2025 20:16:43 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac2bdea5a38so612094566b.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 27 Apr 2025 20:16:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU0RLYqUoeF3dACQ64YcgnAXyPMFYym361ukqyN/WCdDnMTYZeVuYFT0OajiCKdYmi91UvEiPQqGdBMXmX4UA==@vger.kernel.org
X-Received: by 2002:a17:907:1b22:b0:acb:6746:8769 with SMTP id
 a640c23a62f3a-ace71098d77mr1016463866b.18.1745810202119; Sun, 27 Apr 2025
 20:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <aAvlM1G1k94kvCs9@casper.infradead.org> <ahdxc464lydwmyqugl472r3orhrj5dasevw5f6edsdhj3dm6zc@lolmht6hpi6t>
 <20250428013059.GA6134@sol.localdomain> <ytjddsxe5uy4swchkn2hh56lwqegv6hinmlmipq3xxinqzkjnd@cpdw4thi3fqq>
 <5ea8aeb1-3760-4d00-baac-a81a4c4c3986@froggi.es> <20250428022240.GC6134@sol.localdomain>
 <CAHk-=wjGC=QF0PoqUBTo9+qW_hEGLcgb2ZHyt9V8xo5pvtj3Ew@mail.gmail.com> <yarkxhxub75z3vj47cidpe4vfk5b6cdx5mip2ummgyi6v6z4eg@rnfiud3fonxs>
In-Reply-To: <yarkxhxub75z3vj47cidpe4vfk5b6cdx5mip2ummgyi6v6z4eg@rnfiud3fonxs>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Apr 2025 20:16:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjib+vjy9R69+gSC7socoA2tD72vAYk6JFqZ-+4BBFeNw@mail.gmail.com>
X-Gm-Features: ATxdqUFmSSiIZ5FtR5ZekGeIsPhc_hAWXu7IuqzkCaCNgzlj8JjW49lq9NjLN_I
Message-ID: <CAHk-=wjib+vjy9R69+gSC7socoA2tD72vAYk6JFqZ-+4BBFeNw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, Autumn Ashton <misyl@froggi.es>, 
	Matthew Wilcox <willy@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 27 Apr 2025 at 20:01, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> I'm having trouble finding anything authoritative, but what I'm seeing
> indicates that NTFS does do Unicode casefolding (and their own
> incompatible version, at that).

I think it's effectively a fixed table, yes.

I've never actually used NT. Back in the DOS days, you could set the
codepage on your medium, and people did. And it did cause problems,
but they were pretty rare.

People in non-US locales tended to learn to not rely on local case
folding rules for the local odd characters.

[ And I don't know if the Finnish situation was typical, but we
actually had a *7-bit* version of Finnish characters, which meant that
there were special case folding rules where '{' was the lowercase
version of '['. I know, that sounds insane, but there you are.

  Those rules never extended to the filesystem, though, but they
showed up in editors etc ]

> I'm becoming more and more convinced that I want more separation between
> casefolded lookups and non casefolded lookups, the potential for
> casefolding rule changes to break case-sensitive lookups is just bad.

Yeah. The problem is that it's just *hard*.

So when I am made Emperor and Grand Poo-Bah, I will solve all these
problems by just making case folding illegal.

But until that time, I really wish that people would at least try to
actively minimize the damage.

It would be interesting to hear from the Wine people (and Android
people) what the minimal set of case folding would be.

Because I really do suspect that there may not be any actual steam
games that rely on *anything* else than just A-Z.

That case really is much simpler to handle. You can do some really
cheap things like saying "for hashing filenames, I will just ignore
bit #5".

Of course, for *existing* setups, we're kind of screwed. The "two
different versions of the heart emoji" was from a real case,
apparently. Because those filesystems had already encoded the overly
complex rules in their hashes.

               Linus
