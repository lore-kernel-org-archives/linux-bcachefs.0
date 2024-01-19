Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256395821D
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 22:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705704804; cv=none; b=mLoohWp0je04yH1UlIEH3vstLfU6JKH7GeEhXbjWJ0XzZuLWohEIpb9LhQ8ImToGahRjoFBWpOx+kkMU/O0TA62gRzBAgQTftRv5lbqe81KN2dsfbANI8JmvetddmGRiM5vWfjzoR56+L2elRUQTpsEkQBm0xXPpDGC7pHHtIZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705704804; c=relaxed/simple;
	bh=cXFQABVkDQ0a0E3pFCzVsdT8CC/V4HbLE2EFYUk9T0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dBD7kfcmwp181vAp0RSgnq71OtDvEDbz3vhntfl97oaV4KTKtv7XZMnxT13/MmqOBjqy4ep0we1W2WVq9ZOmyzSn3C/dgaGcLZU+kdRnecdqHZgCxvac/e/ahdwDis0J9wqLnIUbQEv3DbtO1dIwfwYxxKJDa84GSO1lD9GdeIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Wsj84mse; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Wsj84mse"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6d9c2db82b0so1197996b3a.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 14:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705704802; x=1706309602; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sWad+tkSe47JjCBUATlLgY9DkjlP39hvBfIJ4tcS5v4=;
        b=Wsj84mseOuuJwWKO5DTTHSZOePaHDDj2v9gpifG0cMQDIJvA47qHZb6hMliEhYd+9E
         vfuSfgoblCtjHtIVQ0Tjbp05dyrQ3EgeQd/0sIXLH9K2CNcqnB3HGCa/xfX4Wck3UBHt
         kj00AktNWWa/WnHZHI7sRgiROmZUW3O8sObMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705704802; x=1706309602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sWad+tkSe47JjCBUATlLgY9DkjlP39hvBfIJ4tcS5v4=;
        b=fj2BuJmd6D8NfGPR+zYnVxMklX6NpKE3DT2cCNWSZGumAQ75GITKGk9YO71gkhirao
         aiN8JYI0C4+QY3+a3UXC2VrIIHelZe7wjWtVkbzi1wG/il/DUaDmd/y/6LPeSyOHHPVT
         jHAu4uptHoptq+RPZxdzl4yDaC408a45AxQ2isEuUyjr5Y9T1ornE1sLKJ0J1AGvP62U
         vdVJb8hM0AJuD5sX7W1aZmasro3eZNq8JrvIydalZ2YiCDdV7E9t2yJGrFa1R5Y5SXJr
         O4pDhs0HBVeahOjGN0yhcRJkNIPdterOseOzfPeWcD1/UW+GNEG5s1Fty3iSC+1mWWkt
         Q9Ug==
X-Gm-Message-State: AOJu0Yxpag+to4wLoNl3cQXGzyVCUqD0kEUCHKwk0QTrLJy/44k2Oxit
	vklS/WKAoM4aX8ByIEe+f7z3F0KYC+j9f4w6jEhn8oSqy6fW4TKQJmOO9phhEw==
X-Google-Smtp-Source: AGHT+IE+IQHn+4YqB/lmtgA3p4J8DA8wXFp6+0CzprVWrwhYC9bV9FJqlGyXVmXghPBe/oDy22G7SQ==
X-Received: by 2002:a05:6a20:3943:b0:19b:827d:ee10 with SMTP id r3-20020a056a20394300b0019b827dee10mr553889pzg.92.1705704802463;
        Fri, 19 Jan 2024 14:53:22 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id pl15-20020a17090b268f00b0028bdc73edfcsm4660022pjb.12.2024.01.19.14.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jan 2024 14:53:22 -0800 (PST)
Date: Fri, 19 Jan 2024 14:53:21 -0800
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Andy Whitcroft <apw@canonical.com>,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [GIT PULL] strlcpy removal for v6.8-rc1
Message-ID: <202401191450.CAF805687A@keescook>
References: <202401191311.B6AA79D@keescook>
 <CAHk-=wj0j07B=n1Bt4EkDJpN5CBmxMuZhv+nnFdi0DxDVSiZAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj0j07B=n1Bt4EkDJpN5CBmxMuZhv+nnFdi0DxDVSiZAA@mail.gmail.com>

On Fri, Jan 19, 2024 at 02:00:14PM -0800, Linus Torvalds wrote:
> On Fri, 19 Jan 2024 at 13:14, Kees Cook <keescook@chromium.org> wrote:
> >
> > The kernel is now free of the strlcpy() API!
> 
> .. still mentioned in docs and checkpatch. Maybe remove that too?

Sorry, I should have called that out in the PR, but the commit itself
had my rationale for intentionally leaving those in:

    Leave mentions in Documentation (about its deprecation), and in
    checkpatch.pl (to help migrate host-only tools/ usage).

If you feel like that's not right, I can either respin or send a
follow-up patch?

-Kees

-- 
Kees Cook
