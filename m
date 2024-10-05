Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FB1153BF6
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 23:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728170147; cv=none; b=AkF1lfbS9neSoRbUOW5bBXj9Qnlh9kJZWU38clCg72A1amI5NtQ94OIlBrn7LrlOH9PAf3SHF2/96zRhoIW9rPMBNf5Xd/LkHCYNhtbj/LV5TcBA8E8aNGZXvDyJZ5oeM8PpYmlm4BKTOaS+fvvYMAEojvk3+cenFblM0M2E+G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728170147; c=relaxed/simple;
	bh=cW9voHQW5KDncJFUKsCyNd2iDsh+IZlwySB2TQy6Ai0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LAgyvdYQCAMUZK18obdtLXzfYOMKXOSLW9D4KN+zLE4MZ/k7iObhoAuIxiDfUqhlo8diD0Vs2cZy8TuPGZF69XXcue8+1WOkq3rz/PDCF6PsMn7qh08JuRyADr6MmP7FUUUvzgaz/95s7XGYRso1PE2rwjELgiUqNjqXdkVSyjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLVYUAVC; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLVYUAVC"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a99388e3009so113695766b.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Oct 2024 16:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728170144; x=1728774944; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NhjXXWdst9jlpC/rp/tuj7IYcehyrssGedcgZn1fDGA=;
        b=HLVYUAVCfMvlFaBG8X00YA0Dw37bZ3CyDKhANJFMm1ziyYzwJcOZJ9Pk9fICoyBXqG
         sB8UWjYXjtJiyCkA70PniFlJAxwFHaXXzkn4q3Ge2nC0KNk3395wKoWDU7lEGOSfekqS
         +ITCsKKB1K01JcX3/czr0JG4r4YeU5pfKO4Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728170144; x=1728774944;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NhjXXWdst9jlpC/rp/tuj7IYcehyrssGedcgZn1fDGA=;
        b=MfrZGq6qF0spznkBwwXOsVaxoxVVi485JUK3Ro3tfb9vsLjQU3E26Km18CW/R8F4Dq
         yOYMRoub0kvCl5WPq6zuKTnMsjSq0i6dDmaHkznt6TSpy6/KqTcWHiF4J165qXTy7Bke
         Oea6cmj/D2Wa/xlIeQAdrZWUPU/eNE+QYngA+GOCN94TVQI19KpdGlGIb5oYSMWJvBAG
         scpYcdHe1MpY9uRYOWfmg79fX81qYwLSFMeweH6/7x26buE/0tda03lfoqa1JwFBcxBq
         zEhl9Nj/MBH3w6S/JiwKzBsur69vlLCCO3I+Ly2NKtIcO8HHUgCV0uwhS8aqriGN/BUu
         Z2rw==
X-Gm-Message-State: AOJu0YwG0ruDm64nKQ+7bFM3smcQFtJz7mIuAY3js+s0nAvfuJSY1QqZ
	nES6wtxmmK6dMjWbESjxiBfb2M+yD+RfyAAqvhrLnEcQPmcnpqNEXmfsrgkud5808C6NSDmRVBF
	orJz4Sw==
X-Google-Smtp-Source: AGHT+IE900UeD/GUake8Pe9c1UpJ9aMKbj6LkQdA3g2tf3atC+kMB+KnbpBkLH33YrHRtZYlstGxGA==
X-Received: by 2002:a17:906:df46:b0:a99:40e6:1569 with SMTP id a640c23a62f3a-a9940e6160dmr146684666b.21.1728170143914;
        Sat, 05 Oct 2024 16:15:43 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9943603297sm81434966b.64.2024.10.05.16.15.42
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Oct 2024 16:15:43 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c5cf26b95aso4278764a12.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Oct 2024 16:15:42 -0700 (PDT)
X-Received: by 2002:a17:907:3e22:b0:a8c:d6a3:d025 with SMTP id
 a640c23a62f3a-a991bd6ae43mr732521166b.32.1728170142480; Sat, 05 Oct 2024
 16:15:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cphtxla2se4gavql3re5xju7mqxld4rp6q4wbqephb6by5ibfa@5myddcaxerpb>
 <CAHk-=wjit-1ETRxCBrQAw49AUcE5scEM5O++M=793bDWnQktmw@mail.gmail.com> <x7w7lr3yniqrgcuy7vzor5busql2cglirhput67pjk6gtxtbfc@ghb46xdnjvgw>
In-Reply-To: <x7w7lr3yniqrgcuy7vzor5busql2cglirhput67pjk6gtxtbfc@ghb46xdnjvgw>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Oct 2024 16:15:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi-nKcOEnvX3RX+ovpsC4GvsHz1f6iZ5ZeD-34wiWvPgA@mail.gmail.com>
Message-ID: <CAHk-=wi-nKcOEnvX3RX+ovpsC4GvsHz1f6iZ5ZeD-34wiWvPgA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.12-rc2
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 5 Oct 2024 at 15:54, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> The vast majority of those fixes are all ~2 weeks old.

With the patches not appearing on the list, that seems entirely irrelevant.

Apparently they are 2 weeks on IN YOUR TREE.

And absolutely nowhere else.

> Let that sink in.

Seriously.

You completely dodged my actual argument, except for pointing at how
we didn't have process two decades ago.

If you can't actually even face this, what's the point any more?

               Linus
