Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1AE7ED
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 01:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RcbXVhLx"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-55817a12ad8so2554895a12.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 17:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1704937658; x=1705542458; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6u030KI6il12QBShR1lcsXxHEUIec68JdndFK14yRTA=;
        b=RcbXVhLxuTvndQgNP5zPdxsAgMaDGuIrCcY58ETZj24DXrGUjns5tAOIE10JNSbOtE
         tj0bK4y5NJLbW2AChovtzJRx7Wnxraziq1NhoxLSwX74PD910tmOpGvd6yeYhFaWTCTp
         +OQjUvQbkqV0fQNUcaAHRS1vEIStocxrTtvbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704937658; x=1705542458;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6u030KI6il12QBShR1lcsXxHEUIec68JdndFK14yRTA=;
        b=p4rBhqkLtL1sszrhLwXqd6kmbBCbK9lvoeVGyfpy2t4vYjc3T8d7LPPKYwSDxVTqP0
         neD/+V90YULYqy/ViPx/mtOUTWmALZIWo4dStWtpY/2PXmm3a5S3ovzbIN8tHOzBhFRS
         HOibyfV98QM6tT8DOOdavGDVsJPYPAiX6+Vv6QnLCB8mMXuyaE+mffDbuwX74Av1a6EO
         KVYTXZNmi3oXIUfD6aaj04gUZjG4ZrqRQrjzTxBer+cs8DOO1bFH1XMhf02bonyl5PdL
         CTC7an3MsYZp9YijoW2Zumb1Ed/V77XcxbXwoK7hsTceXnk9wD20XnN9M9REoLXCT05F
         XSIQ==
X-Gm-Message-State: AOJu0YxSUlBVVMi5/1Zyd7V/XtNQjzEImcfb7+Qk1bkoPDX6n6ExVQk8
	2sq0DLN9Qn482FW4QU7w65vrhEzcU+CqyIB4Kg0ld0jxO+y/0wIg
X-Google-Smtp-Source: AGHT+IEhECLuMDmFNKFhZnmExXtEFToQ7rC56erac/HWS7/lTbjMK9udCljKcaqT03miMbupoUCcfQ==
X-Received: by 2002:a05:6402:1517:b0:557:523e:c1ff with SMTP id f23-20020a056402151700b00557523ec1ffmr152856edw.76.1704937658592;
        Wed, 10 Jan 2024 17:47:38 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id c10-20020a0564021f8a00b00557d29be289sm39356edc.11.2024.01.10.17.47.37
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 17:47:37 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a28fb463a28so489952266b.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 17:47:37 -0800 (PST)
X-Received: by 2002:a17:906:abc3:b0:a26:8ee9:9b31 with SMTP id
 kq3-20020a170906abc300b00a268ee99b31mr175059ejb.4.1704937657031; Wed, 10 Jan
 2024 17:47:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <wq27r7e3n5jz4z6pn2twwrcp2zklumcfibutcpxrw6sgaxcsl5@m5z7rwxyuh72>
 <202401101525.112E8234@keescook> <6pbl6vnzkwdznjqimowfssedtpawsz2j722dgiufi432aldjg4@6vn573zspwy3>
 <202401101625.3664EA5B@keescook> <xlynx7ydht5uixtbkrg6vgt7likpg5az76gsejfgluxkztukhf@eijjqp4uxnjk>
In-Reply-To: <xlynx7ydht5uixtbkrg6vgt7likpg5az76gsejfgluxkztukhf@eijjqp4uxnjk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jan 2024 17:47:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wigjbr7d0ZLo+6wbMk31bBMn8sEwHEJCYBRFuNRhzO+Kw@mail.gmail.com>
Message-ID: <CAHk-=wigjbr7d0ZLo+6wbMk31bBMn8sEwHEJCYBRFuNRhzO+Kw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs updates for 6.8
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kees Cook <keescook@chromium.org>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jan 2024 at 16:58, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> ...And how does that make any sense? "The warnings weren't getting
> cleaned up, so get rid of them - except not really, just move them off
> to the side so they'll be more annoying when they do come up"...

Honestly,the checkpatch warnings are often garbage too.

The whole deprecation warnings never worked. They don't work in
checkpatch either.

> Perhaps we could've just switched to deprecation warnings being on in a
> W=1 build?

No, because the whole idea of "let me mark something deprecated and
then not just remove it" is GARBAGE.

If somebody wants to deprecate something, it is up to *them* to finish
the job. Not annoy thousands of other developers with idiotic
warnings.

            Linus
