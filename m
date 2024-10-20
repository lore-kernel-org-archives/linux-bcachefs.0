Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620AB1DFD1
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 21:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729459864; cv=none; b=h8YG3GNGcfHz9oAu5fq11ZFGx6gBaFhVAgyEo6n4Heb/zUSw3jIV542JFSLMRi+gohYNmxH81B5bukhoOxNeHGvH+CwtPaItzUAB6/8oOPeIlIbsjNgy2BI9vhW95CENJyrstTnuPpKDr8kus0KMCo72YrdzMuVHC8du34Dwn4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729459864; c=relaxed/simple;
	bh=ykaFoPzGaMCoE7bj6EsoDwlvaRxZGvoiIAX2PsLNjm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzngoF9hBPRgCb2I2K4XjRjvbumgSCElPaIgI07CL27BRb4zP1A8PNwSScaBO6+XDchmvDA+Ok4w+f9x1aQp1b355KISfzbYNa3DYe1XPiDUay/aVo/YinQ/IR2tMIgUOfxEc9tCBtLZbVpiJ0LFRaUwzdHzFwjAqcG5bou5b5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q64lVzq5; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q64lVzq5"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a99f629a7aaso676325066b.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 14:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729459860; x=1730064660; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3gsbLturYiOoejv++RiooxZpHIdZVaSyoFSqS3AiQqI=;
        b=Q64lVzq5M496W6TZUtDyydCdhO3tEqN92vkxjIHjsvTyRc8fxrQq/lSbrs1FcTLOOe
         1Mh/w0+IEPaGpj/10s2GMQg9ihtZbmvPnQWqllgdPSxsCothX+oiNxUqDCQaGOjmzty1
         dLZR4XL7D3BZ86ODDI3JcKUz0YaMy1olHJicE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729459860; x=1730064660;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3gsbLturYiOoejv++RiooxZpHIdZVaSyoFSqS3AiQqI=;
        b=VR9OzAMqUIdl/QcEykZDXntTiYZrQudDHtAHuLcfyTkz3efr8aQSSl2jf4rtgGIBEy
         kqCdvKZ/XYc+bMarmGWZFmEJEAS78sXC/I4rK/fExZXB5ifOpsslAOtFk4WnIt4Z9jIW
         eseikh5ISOQPXd9pt29XGBYA/xYTkvMP0HCLwu6Erk8WXuaa/ZVd6IgUD5KG90zgE0he
         +Rx4rGv7hVeFaNbrXx4zjFD26cE5afd2ZMhlz71Lk2Z0SCEKqiqcaBjtF+3/CvoCQJ1F
         kibsRW/6KWXW6qXCfWoLPILeoGk/yjrNH7n2Q/JBzvsbdsfamojjCLJr5clmOar+FS22
         B3ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU91PR52J2zB5OGvk4A45Gqg/d+z3GnscKScrkvq+Yoke9YL2PWld0A5l9FGWA2cT68JmJOpUS4JejcUZcig==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyzWCMowNg8J5k0aNQQ2QaR8X3gicx5GtgizmXYNaRqokIHds3
	LImy5OLcZ0HZw42tiJn1dbh9n/o+1gZdYxkpLsGBT0lTMnw0e28i6RcdI9TdNIZ4KWGgG+34W+O
	trgRmmw==
X-Google-Smtp-Source: AGHT+IFIK46uEp9BYtfU9u5MOo9FISFFkysfrluo/wN5x7Y/5cIsQfiHADI74QEgjWxz/YD7AVgosQ==
X-Received: by 2002:a17:907:d16:b0:a99:5f65:fd9a with SMTP id a640c23a62f3a-a9a4cc3c202mr1573094066b.21.1729459860358;
        Sun, 20 Oct 2024 14:31:00 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912edff8sm126977266b.59.2024.10.20.14.30.59
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 14:30:59 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a99f629a7aaso676322766b.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 14:30:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXgBHEZLnXtlY+F/MuG3YCmuG7yYhn8eF1plyq2acUYzNh7UexI3welYws7G0z7kNsCpkEo8GbnK28V4czGwQ==@vger.kernel.org
X-Received: by 2002:a17:906:7955:b0:a99:ef65:50e with SMTP id
 a640c23a62f3a-a9a4c2ed7f6mr1568592766b.11.1729459859390; Sun, 20 Oct 2024
 14:30:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
 <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
 <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com> <zsx7jruj2lefbippol3zgagkw3sk33pgli476y2rumq3k25xkm@rt6ady5gnkrv>
In-Reply-To: <zsx7jruj2lefbippol3zgagkw3sk33pgli476y2rumq3k25xkm@rt6ady5gnkrv>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Oct 2024 14:30:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5o2ZEk=H_fy=1nZzUxTR8djjDhPp7yV7_5YCA8xQUXw@mail.gmail.com>
Message-ID: <CAHk-=wh5o2ZEk=H_fy=1nZzUxTR8djjDhPp7yV7_5YCA8xQUXw@mail.gmail.com>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Oct 2024 at 14:29, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> That's the same as limiting the amount of dirty metadata.

Exactly.

We limit dirty data for a reason. That was what I said, and that was my point.

Excessive dirty data is a huge latency concern. It's a latency concern
not just for journal replay, it's a latency concern for anybody who
then does a "sync" or whatever.

               Linus
