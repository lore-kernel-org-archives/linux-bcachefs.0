Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BED845949
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 07:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191647; cv=none; b=oCARRUkKaCVFvVa3O99Wx0xmYCMztIqx8ooOh7s0Qq9gqUdIOcoAYOngz3qm6OHH+zx6CbmleukDKG3QGVQit62TCFS+xEZ1GSvVxuSpaZm0txkO7B3d4L9cQoiYANV6BgqKnfGohK/+5MrMVCAErAvz0O22Pky6mm1NhnQxgjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191647; c=relaxed/simple;
	bh=gj0srNm4dhyxwVwQnx30g58qYENerrA3OScXTEwvqjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y2r2afkYH0I1W5m6DUc+3GaMdQUOJEOG0IK8JY/wLH445Hysbo/uhbx/TUeKfsLSXd6NS6mewUhKaXkHFUZmGND0YNuxnEclGL7aYb7UAYwUzdwl3um9ltHXqO06q+POB12tsQWhijfgr8iSR4vx9isf4v4W8StEAQM8AfOBtQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NJORgpR2; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJORgpR2"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a43f922b2c5so71988466b.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 23:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1709191643; x=1709796443; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hmnTRedH8O3pT6nT1reFMuPDuDJUr60IhrC8tjvNdqw=;
        b=NJORgpR2z9aWJmO7EFX4CUzuFS7zB6gUVA5TBnrFKod3Jb59Nopi0Ub/Qw33tpkArB
         XBRuoqI3nfdBuxBQ6r0Wc/CFTqOV/HXAJmzXzo6TeDYDWh8P0cs1jeqggTsiuJ5AImcY
         2F3ajeVCutUz1/V8QQ7LEXzBFESSPP1J76IgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709191643; x=1709796443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hmnTRedH8O3pT6nT1reFMuPDuDJUr60IhrC8tjvNdqw=;
        b=TJcMnxzsdC4Ywiiw1r0dSWw9E5G7KNwVxQ3Icsln2xziEFPEkCu0tfQGB1fjhRC5kq
         MSY8vje1FNh9P6ZGY1qkkf3WSpZJfzKeU0WUzJMAK7UZKoDWxadFT4w2at4qF68+SLSd
         hpMq/rv70JWJHv8oZQJAU+Dm2XwnSWwquBpWHRgGJ4JtFu//Hd7bjquXCTrNMg36UYZ/
         nG8niOQhPhMChf5NAiIx0Uol9L7JYufPRd6X9kXH6HtpgAskFfgxc3tQuMNi4tdye+hd
         U9vrMY9bUSwvNoqpppf0/YiwV5GHXqYS8eW+YkQo8B9sDy/VLV87VVmTlJd8IPBL8+9Y
         7Rdw==
X-Gm-Message-State: AOJu0YyOMjJnqZm8/y8Dh2RX8IUBOpwNq1/oq+nGYdq7b771lTZnwkcH
	9rJDwj2Y2Ge/cPni++YJR+Rx+ozbcqvZlN37wO2sGP+WnVg+mnuJUWwns8Cl2ZKiQ6EPn5eJeK3
	2C1IZkQ==
X-Google-Smtp-Source: AGHT+IGDIPEjc85s06ifzpazb5JfAIhDgvBPUX2nx/G6kUwxAfkGeuiyBNSbGkN3a2L16cDWAGhvSQ==
X-Received: by 2002:a17:906:2409:b0:a44:512e:9e44 with SMTP id z9-20020a170906240900b00a44512e9e44mr217969eja.7.1709191643140;
        Wed, 28 Feb 2024 23:27:23 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id mp4-20020a1709071b0400b00a3d11feb32esm381520ejc.186.2024.02.28.23.27.22
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 23:27:22 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a36126ee41eso93806266b.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 23:27:22 -0800 (PST)
X-Received: by 2002:a17:906:ae49:b0:a44:4610:6aad with SMTP id
 lf9-20020a170906ae4900b00a4446106aadmr466351ejb.11.1709191641702; Wed, 28 Feb
 2024 23:27:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229063010.68754-1-kent.overstreet@linux.dev>
 <20240229063010.68754-3-kent.overstreet@linux.dev> <CAHk-=whf9HsM6BP3L4EYONCjGawAV=X0aBDoUHXkND4fpqB2Ww@mail.gmail.com>
In-Reply-To: <CAHk-=whf9HsM6BP3L4EYONCjGawAV=X0aBDoUHXkND4fpqB2Ww@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Feb 2024 23:27:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg96Rt-SuUeRb-xev1KdwqX0GLFjf2=qnRsyLimx6-xzw@mail.gmail.com>
Message-ID: <CAHk-=wg96Rt-SuUeRb-xev1KdwqX0GLFjf2=qnRsyLimx6-xzw@mail.gmail.com>
Subject: Re: [PATCH 2/2] bcachefs: Buffered write path now can avoid the inode lock
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@fromorbit.com, mcgrof@kernel.org, hch@lst.de, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Feb 2024 at 23:20, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  - take the lock exclusively if O_APPEND or if it *looks* like you
> might extend the file size.
>
>  - otherwise, take the shared lock, and THEN RE-CHECK. The file size
> might have changed, so now you need to double-check that you're really
> not going to extend the size of the file, and if you are, you need to
> go back and take the inode lock exclusively after all.

Same goes for the suid/sgid checks. You need to take the inode lock
shared to even have the i_mode be stable, and at that point you might
decide "oh, I need to clear suid/sgid after all" and have to go drop
the lock and retake it for exclusive access after all.

(And yes, we *really* should have a rwsem_try_upgrade() operation and
at least avoid the "read_unlock -> write_lock" dance), but we don't.
See a comment in mmap_upgrade_trylock() about it. It should be
reasonably easy to add, but we've never really had enough reason to.
Maybe somebody decides it's worth the effort)

               Linus
