Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5111745C5
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Mar 2024 17:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710436560; cv=none; b=uLYk0d72b+p0Tn30ZTliVXRm6BsTDD454hJHngtZIJZ8pLYxevOCc5IoiHD3PJyxCqaXGMW4GeshbV/rm6mi5UV9uv+OcbWMH9TFkwmX8CQyZk0rDD1KzMES5MzdzYFEUnWJiitC9mSFhhC0/5pYP8868YmDEGm6K83d7chFaiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710436560; c=relaxed/simple;
	bh=ASo+LDsMApRbUXPpMln5pwSC4HMvJj/Gm7MdWQsFt1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ix4UB7Whz670OLpeJxhd+G0uOrm6tN4TKde8GkUpjq8KpBe8dBg3nPKcBwdfqmhEVZ9uicEYb0wEcZMpQNYT6/T2rGuJFxsJTbQbbHORj9TdNOaKXP/BEB7b0vcKGdMnAZUQViMziFtuH0CHb3V71HoV6vjyKDYH1t9pv/JGsW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egBYLjzN; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egBYLjzN"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-565c6cf4819so3804577a12.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Mar 2024 10:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710436557; x=1711041357; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=95r3OCCclHMX2hfHWchTVWQ72JjnvU4/ijqwnCext1M=;
        b=egBYLjzNyavAZpzF1XcRfh/wH6l+W99Ub6q5Kg2yw+Xz/DcKV2cQ2CxyMqRTBp90OI
         av4A0Cqvvo8KLTXbOhR0M9BpfRUe0JyPRuche4MGPK7ag1IgvzozO5DGCWaYySItwKfp
         1qwQNvDUPUFhQqiM1QT2ebx+AB8z003K6OzgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710436557; x=1711041357;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=95r3OCCclHMX2hfHWchTVWQ72JjnvU4/ijqwnCext1M=;
        b=bRHCu0D737Ti912iuHaM96MOI8yLGsKKP3ZhyL3EcAKnHIwB0uV9zpzOD0vcrrhTVo
         bA8E32nTCSSdVzuwkrU6sRsKZIis465Tdd4EudTRUn2qURRbnnfu7CgFjN12WV+znlHF
         BKD7bB370/ISx87RZdu1TtRY9A21IX6Q8mfDbuqX0LcjNClKRdJuLHlvxH8s/6BMU0qq
         7v1qg4ZLmKbAxULX82xBkK7A4OLj6Bop+m2l+7D3aH7fOukwHB7XwXW5fhJz5wYXsglj
         8zIHWP5dwbBz5SDU2B7ZdFLALGyLE4PMmwDMZmVFYDR79CYaNxfxAs10zneFzJW5hPnS
         olgg==
X-Forwarded-Encrypted: i=1; AJvYcCWjgT7n9C+bikeC2ZMGdT1FJLXYhMNidJdIV5fka3cK7bXWrDG9RNpNlfUy7Y1iLgH/LxFXFZjo19D+RrrZLkgIu9n+mVLBjMA6En8n+bE=
X-Gm-Message-State: AOJu0YziFgpJ3K629xr3ARGildMr87c2CNbL2dvohxa+prlCc3p30ru5
	rJ9LZ4wqZX002P+E+NGW0ThmwAPhuOXpI9PTKggDY17X6TAm4o5QhU8N1kOHt6MfzHte30SE6WW
	/aXk3RA==
X-Google-Smtp-Source: AGHT+IEiiTRCTntFfdD661ZHYD7W5xBpZKJU62iIoVhKpoB8gRmHZspiFIwa3F23iqn8MjR6Hfwa4g==
X-Received: by 2002:a17:906:903:b0:a45:40e4:8c8 with SMTP id i3-20020a170906090300b00a4540e408c8mr6088026ejd.16.1710436557042;
        Thu, 14 Mar 2024 10:15:57 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id d10-20020a170907272a00b00a44ef54b6b6sm883511ejl.58.2024.03.14.10.15.56
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Mar 2024 10:15:56 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3ddc13bbb3so416858866b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Mar 2024 10:15:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWpaG/gSt68JmZ99uT048DnW3fDcebM8BxBxWEq+vKs2LdnbuEnlgRIFYaKXiFL8kRy1aNnKqCSb1MEtoBIalmUnsPN4PgUTEtdS3TiwqI=
X-Received: by 2002:a17:907:1b0e:b0:a46:4ea8:9df5 with SMTP id
 mp14-20020a1709071b0e00b00a464ea89df5mr6915486ejc.5.1710436556101; Thu, 14
 Mar 2024 10:15:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <lfypw4vqq3rkohlh2iwhub3igjopdy26lfforfcjws2dfizk7d@32yk5dnemi4u>
 <CAHk-=wg3djFJMeN3L_zx3P-6eN978Y1JTssxy81RhAbxB==L8Q@mail.gmail.com>
 <bqlnihgtaxv4gq2k6nah33hq7f3vk73x2sd6mlbdvxln2nbfu6@ypoukdqdqbtb>
 <CAHk-=whbgtooUErM9bOP2iWimndpkPLaPy1YZmbmHACU07h3Mw@mail.gmail.com>
 <hbncybkxmlxqukxvfcxcnlc53nrna3hawykbovq3h3u5xpm7iy@6ay4wjnpuqs4> <4q5fetc7qwunhhvieuiubk3g3guc4mr4a5wfmn5u4ox6kyo4p7@olyanpabfvav>
In-Reply-To: <4q5fetc7qwunhhvieuiubk3g3guc4mr4a5wfmn5u4ox6kyo4p7@olyanpabfvav>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Mar 2024 10:15:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgaWNYqrH=DSMiKTtb0vO-9JZ8Vm7VQRT4=uprsaT0eMg@mail.gmail.com>
Message-ID: <CAHk-=wgaWNYqrH=DSMiKTtb0vO-9JZ8Vm7VQRT4=uprsaT0eMg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs updates for 6.9
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Mar 2024 at 15:28, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Sorry, you were talking about mean absolute deviation; that does work
> here.

Yes, I meant mean, not median.

But the confusion is my fault - I wrote MAD and then to "explain"
that, I put "median" in my own email - so you read it right the first
time, and it was just me being sloppy and confusing things.

They are both called MAD in their own contexts, and they are much too
easy to confuse.

My bad,

               Linus
