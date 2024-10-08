Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED8DF71
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 00:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728348878; cv=none; b=gTcS6VZqPHwBxSs0F5jum/7LH+rN48ThbXLb7NG5oiQ4Yg25Y1Hoh5lNx9Hwk7e8T21y/rOZVXRZNAuJw4XO54Tcw6J3sghUrPm1ZN5Bt7rklEE1iKtpBFymOrIUXkQUUIj1RlpZln18Abe65fxRON3VxgMDdwZmAljcvDog+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728348878; c=relaxed/simple;
	bh=NqYO63ftG4Vh81Um6zsjfmC5SEgFzFYHUlSf+opM8ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b4LzzznWe+5dr1gl90C2yMRhgjHwiFP2agYIJaZxPHmAR5O2k3BK/3dhG2C7ne42e4usR+wkjcxJtzaYT1gxPFLKWTodiiBMk/PeQPwshh0abgerCYJi/iRC6fE2ZrPhEJj+UHx/sZtiJ8s5RoP74mTZV/S3LC0PDal/d85+53Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdaZhrdV; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdaZhrdV"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5398b589032so7584454e87.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Oct 2024 17:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728348874; x=1728953674; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tnmN82gruhjoauaDPVFxp6c7gOVhPQGFyw+79HJzqU8=;
        b=NdaZhrdVGnvC+ynbG0T9KCf7DMjktaeRH4d4I6bNUmXk6Ilf1uLQo+62QMJeoeYD/O
         t/anE2EUJPZC+Jg3HfplLd1VxFoiK1cbfEqGiVFasyiWbSZH9caf/Y2rwIbjw0BG4tR8
         e4AvmBDn0+VOW6eArHhZ20eckBBH4xwa3Qdec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728348874; x=1728953674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tnmN82gruhjoauaDPVFxp6c7gOVhPQGFyw+79HJzqU8=;
        b=mX/locGkhcOBHsTBW+zn74+xfkQRoIf1Rfb/b94ccYezuDyTsNXBlcYwK/uL95VF6m
         UBIF/L9eWqKEJWtslJfFpMK95gPNIgpyumBdgOacY3y5ANg5yq1hdjoPHZn72I47vk+F
         gArad4rJ6y5ixWVwi+updfYYM/lOWkkK/tTIfQFIrTV33f9Za5SeIVQtC1h+6j4QhORZ
         LLfJGBxQuiVDBqmb3MaFUDkEpxN90r6NLzaX1MEO/OpGCpSuvEEROncdcjTJCMGUHnJK
         8FrS3xxxJndZRp80XI1CCQg86sB/L23MAd0+vUCUbqaXtF81ER5YRAfzmoGQ9UCbuDly
         34oA==
X-Forwarded-Encrypted: i=1; AJvYcCWMcRCYM4hF6eanwprvBvQG0FkArr6eqaEIo0l7fhaGzqI4gmQFk9yxIEy+g8IupsrcUAWS4pBxp9JqrvWcOw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9Xeg26Hhc6zAL7QxujZBFHZwQpo8UzXt+waemal2OA+UkCwY6
	UFjzIQA8Zr2DgiSDxf3gwV4T018DfN1qyXpPNOzpisB3TaMtWZe1lDzIAqTXmMMbPir/oOTtfXN
	ZOefHRA==
X-Google-Smtp-Source: AGHT+IGbPSy/tVQDyaBgxKqhgPhfOXO3AgoXjhPrjRcroUN2yKKIm+3pDY/ehDiUU95mTMwlx7YH6w==
X-Received: by 2002:a05:6512:1256:b0:536:741a:6bc5 with SMTP id 2adb3069b0e04-539ab84e0ebmr7385100e87.12.1728348874183;
        Mon, 07 Oct 2024 17:54:34 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-539aff28077sm1022909e87.255.2024.10.07.17.54.32
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:54:32 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53991d05416so6069372e87.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Oct 2024 17:54:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXyG+P9pNu/dOlWEWY+vta1GrunA73Xkkl+JSaPmncd5a2+IZBYniyTSThU0StuW7wua/m1aYcoTOoTxLAiNA==@vger.kernel.org
X-Received: by 2002:a05:6512:3d07:b0:52e:fa5f:b6a7 with SMTP id
 2adb3069b0e04-539ab8659c5mr8118408e87.13.1728348872429; Mon, 07 Oct 2024
 17:54:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002014017.3801899-1-david@fromorbit.com> <20241002014017.3801899-5-david@fromorbit.com>
 <Zv5GfY1WS_aaczZM@infradead.org> <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3> <CAHk-=whg7HXYPV4wNO90j22VLKz4RJ2miCe=s0C8ZRc0RKv9Og@mail.gmail.com>
 <ZwRvshM65rxXTwxd@dread.disaster.area> <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
In-Reply-To: <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Oct 2024 17:54:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgW0RspdggU630JYUe5CyzNi5MHT4UEfx2+yZKoeezawg@mail.gmail.com>
Message-ID: <CAHk-=wgW0RspdggU630JYUe5CyzNi5MHT4UEfx2+yZKoeezawg@mail.gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert sb->s_inodes
 iteration to super_iter_inodes()
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	kent.overstreet@linux.dev, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, 
	linux-security-module@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Oct 2024 at 17:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And yes, this changes the timing on when fsnotify events happen, but
> what I'm actually hoping for is that Jan will agree that it doesn't
> actually matter semantically.

.. and yes, I realize it might actually matter. fsnotify does do
'ihold()' to hold an inode ref, and with this that would actually be
more or less pointless, because the mark would be removed _despite_
such a ref.

So maybe it's not an option to do what I suggested. I don't know the
users well enough.

         Linus
