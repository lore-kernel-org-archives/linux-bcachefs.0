Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9261433D8
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 03:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725161151; cv=none; b=Yg8kA/E9a1ukCYGj1TWF8WfL+W9OeKm+rbIM/G8t5sgNSRqG/e4QPJ6GrYFAl0VuXTwwCkIgf4yx895Ge5jj6W6S2Ueu5moJdli2Gp216JOcyjGvtPphYUzTCZCP2YBGUvIiN+8pYrsrxBSr3fp/EaXYjd8w19jfjcA42BnlTow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725161151; c=relaxed/simple;
	bh=tcx579kBQXIkUt0k10DF9rAN3Ao81wX5xr2qhmf8S40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mNgYKVIWZ3mqKBi5hpu+6NcA8wFfl7lWa3EGJUmVsGs63T9rOKYQNlw4UCyBZ5MrLQPtZ/Iw8fFCZ/82awfLMmGuLFOAoU1mgxq9uAlJYVEggdea568qOZH4qL5vqbbAiq3qopnNZyoDithNjBS9uNAAM15MmT02Kt4PDCTEvag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LrKxlBWt; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LrKxlBWt"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso4177456a12.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 Aug 2024 20:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1725161148; x=1725765948; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HC1nsfFJXyTdVWcxISQi1WPBRNOn9dIaZqfB6NKeE50=;
        b=LrKxlBWtjE2xqlrQmaV9zYbQ2MfN8g253Ik5YzjyBZzHvRQa5rwxbYxdu0QLA8ijbO
         EHFM1z+KI6YOQUy765b/xBrOmYzJwsx3iLIjEXix0bl+W7P2EY9jjxjTD7dEcZqj0bvW
         4P5moMkrriuXI6MenWFum6B7QMwcbw/LIcpAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725161148; x=1725765948;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HC1nsfFJXyTdVWcxISQi1WPBRNOn9dIaZqfB6NKeE50=;
        b=FJfkikbRmvsn82VmEJPN+oFgfa8qFJeYe109cWCNkkJQ3FjHi92hv0n2kNZH/CuJ2W
         6tG0cZY0vd+Y/Zo4vy0zVs48LmA2jIqyXawR8EiLw//aExapOtRP5NJW9lkHC+s+ABRG
         NdESzOt48mUkIp8LemgKSuVU2aPlH3T720UMuMpe70zpQiHM0mmwAgP8KnDrlOhIV4iz
         8cT2OJi9JXFNjzyiTPKv8UWoLda8OtDZ1t70ky4IcJeTktxHCIOP3Qk8arrmgiA9BIA5
         8DVRVOy2d1giag1JIpOUl6UkLRysTVsEKRUvChEvLkTjzB5i/Ucr216HoVGMWnx1N/gT
         aDUQ==
X-Gm-Message-State: AOJu0Yx/Wta4XaJvWMv5rG4qKaq8ST5igqvYmvwWXVLYg5a62yILz2A8
	Sd8C6Zggg4EN/X48TPSXdJL3062o+XEOSDYqZQwyrskXzxck9zTGJj7qEdVNyYrJTsX7goEjMJc
	iw0s9Cg==
X-Google-Smtp-Source: AGHT+IHQWC1gacjgKoxWHN1lW/IG9c9eHmVzwEIYOe/TEiCBgDu8KTm/L+SnHDfm1uPQGGd5CE9cTg==
X-Received: by 2002:a05:6402:42c7:b0:5be:e9f8:9bbf with SMTP id 4fb4d7f45d1cf-5c21ed406dbmr7079658a12.9.1725161147143;
        Sat, 31 Aug 2024 20:25:47 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c24ff04551sm667663a12.35.2024.08.31.20.25.46
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 20:25:46 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5befd2f35bfso2800812a12.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 Aug 2024 20:25:46 -0700 (PDT)
X-Received: by 2002:a05:6402:42c7:b0:5be:e9f8:9bbf with SMTP id
 4fb4d7f45d1cf-5c21ed406dbmr7079645a12.9.1725161146176; Sat, 31 Aug 2024
 20:25:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <erydumpfxcjakfllmh3y4d7wtgwz7omkg44pyvpesoisolt44v@kfa4jcpo7i73>
 <CAHk-=wjBNzWL5MmtF86ETJzwato38t+NDxeLQ3nYJ3o9y308gw@mail.gmail.com> <5q6h447wzxlskkvgygm3xb2tasbbgmmtxsxd6m4jtygpwsf47b@hxdqfn3nxqzo>
In-Reply-To: <5q6h447wzxlskkvgygm3xb2tasbbgmmtxsxd6m4jtygpwsf47b@hxdqfn3nxqzo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Sep 2024 15:25:22 +1200
X-Gmail-Original-Message-ID: <CAHk-=wjPQWyYf0Jg6KG2gUYz4HEPq5BT0N=Vx6ECOx41TGvZiA@mail.gmail.com>
Message-ID: <CAHk-=wjPQWyYf0Jg6KG2gUYz4HEPq5BT0N=Vx6ECOx41TGvZiA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc6
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Sept 2024 at 15:19, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> odd, everything looks quiet on it, but it was acting funny earlier today
>
> I do have a github mirror though:
> https://github.com/koverstreet/bcachefs/ tags/bcachefs-2024-08-21

That works. Thanks,

                  Linus
