Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB721BA263;
	Wed, 11 Sep 2024 20:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726084987; cv=none; b=MUiLynN2Y19f5eOLzz+YxxBXKaj4f1GsHCI/J8FX41fWZUznzK3PSI/RSggLsZoUheTNqHeRcp4vJdgA8DGsH0dpYk9jrU2zqgf1TlpLTeM+8aDWBMKr4DCdZC/4s0Qq2IPh/WimCjvP/tSbUwDQq21fJ+cc2FZEZJhltJrdJJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726084987; c=relaxed/simple;
	bh=Ua2dyT0bhSolwHUdXhnJ62p4G9dhMQk2hp7qVP5oi2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRWigY6vsBQjAXrwOz1kfZpgh6i4nQfbONZ8SWQUeplhYh3G33geis7lryhJ3a28nqZlfbI0JRhReRPw6wEjC6dU8KBBF2tBd7DX5cbBxA89Mq6zrm7IFC2PE8se7Nq5Wj5BD8+27+vuEpgTTW2rVtKeqjLY7kzY+HNSZmRWV5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R7QxJN3i; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7QxJN3i"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-2705d31a35cso114382fac.0;
        Wed, 11 Sep 2024 13:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726084985; x=1726689785; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HQHsFhjPJ4u+X/sv7+YjlA9uC7lJnoJfGgxEewlbqwE=;
        b=R7QxJN3iZ7SUPQMLbjgQeTGh8yfky1ftIy6Keo/glCzRJi9Ec8pZdplkB+Cm8rqd9N
         /oIjTyvOxgyeMaaG9i14SkKJhkb8pzZy2FiOR6keB7JMFcnRbghR6FYGcqT4QaQf8naM
         ODolX9a4mdmXYZ8RCNsPp5Shjb6xhqPCnWOVHjD/s54RlnoOAyx+8tmMK/I4vqMZumGz
         Nub1b/xFb3SlobWM5jhdctiOzteqn6nH1Rfji+12QKHy7lLZLpn175V6db5mLwEf7EpZ
         C/lIE22croo76jS9liHStBRVj0w9VlPXGCYYDkvd2jycq/b+m0p0i2V4B9dmEMVh12h1
         GjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726084985; x=1726689785;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQHsFhjPJ4u+X/sv7+YjlA9uC7lJnoJfGgxEewlbqwE=;
        b=Uvk0p3DcXDkJE8pFY/qVv7lyVYg7/t1cU7bWVB/j81xRWKSC2547TeBW7KCc6PgWeo
         YipeK89EbOVKkXR3LUJuC0tHdsPE/DXDAIeYNiRhwNoKRzP7qPrxeUCECzP1Rjt9t1PK
         n0/B3FcuayYqa/0+jVlwHF077ZjES3Y+ExNc0NfyGQtJHeQzNl9vEOWwKS6hrEpF91u3
         lchDcI/zogZvMhmNoLXoJM5JIcc+rqXgNAoz+QBJpm8qi3sz38xmzb+Hp/PDekfRosaL
         nHcgF0VHO7XyfYkYmmGyi+dG69C/STUuuD7wJacShgme7HNGgaC25/ocB+UuVwQ4yq7b
         JcIw==
X-Forwarded-Encrypted: i=1; AJvYcCV8rq1IgHJCv25HUES5Q1ukTi63MUu7XQHxCEKjVkPHZvi76WMVrKBaVPgYHwF+nlw7+pNveiYVHaYUjKkn@vger.kernel.org, AJvYcCXrUKtokBPA25s317D8keQPNZBAmEaK60RuldopIrhlueSHWdHhTeuREcaJ7P0hg/WqLRpXgXsMBJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1tJTPEbgk/dBj+ZmitfbK/NCa/QKHTWksMF1l11cy8LJXUpU8
	ZqsNyc8RjfqYVzH28aYx/FpbDi+AWTOf65B+0hfpU5HlKRh9LBdk
X-Google-Smtp-Source: AGHT+IGoEN7tjp8D0vGuh4GjGOzfj9HpsxK+4aKeSYIebuZstvT9U6+BsV6Ie18HdRlFYsfu54Zeog==
X-Received: by 2002:a05:6870:b296:b0:261:211:9d0d with SMTP id 586e51a60fabf-27c3f6a6e05mr399337fac.40.1726084984794;
        Wed, 11 Sep 2024 13:03:04 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:dff5:4180:2562:4c1e? ([2603:8080:7400:36da:dff5:4180:2562:4c1e])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-710d9d6fb1bsm2515215a34.48.2024.09.11.13.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 13:03:04 -0700 (PDT)
Message-ID: <200ce66b-845f-4f20-8838-619646f5f44d@gmail.com>
Date: Wed, 11 Sep 2024 15:03:03 -0500
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs:fs:fixed some spelling mistakes in the bcachefs
 coding style page
To: Dennis Lam <dennis.lamerice@gmail.com>, kent.overstreet@linux.dev,
 corbet@lwn.net
Cc: linux-bcachefs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240906195720.40315-1-dennis.lamerice@gmail.com>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
In-Reply-To: <20240906195720.40315-1-dennis.lamerice@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 9/6/24 14:57, Dennis Lam wrote:
> ---


Change the subject, it needs spaces to be readable:

"docs: fs: fixed spelling mistakes [...]"

Also, you need a body in the commit which includes an explanation of what
the patch does (even if it is almost the same as the Subject) and your
signature. See: https://docs.kernel.org/process/submitting-patches.html


>  Documentation/filesystems/bcachefs/CodingStyle.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/bcachefs/CodingStyle.rst b/Documentation/filesystems/bcachefs/CodingStyle.rst
> index 0c45829a4899..b29562a6bf55 100644
> --- a/Documentation/filesystems/bcachefs/CodingStyle.rst
> +++ b/Documentation/filesystems/bcachefs/CodingStyle.rst
> @@ -175,7 +175,7 @@ errors in our thinking by running our code and seeing what happens. If your
>  time is being wasted because your tools are bad or too slow - don't accept it,
>  fix it.
>  
> -Put effort into your documentation, commmit messages, and code comments - but
> +Put effort into your documentation, commit messages, and code comments - but
>  don't go overboard. A good commit message is wonderful - but if the information
>  was important enough to go in a commit message, ask yourself if it would be
>  even better as a code comment.
> @@ -183,4 +183,4 @@ even better as a code comment.
>  A good code comment is wonderful, but even better is the comment that didn't
>  need to exist because the code was so straightforward as to be obvious;
>  organized into small clean and tidy modules, with clear and descriptive names
> -for functions and variable, where every line of code has a clear purpose.
> +for functions and variables, where every line of code has a clear purpose.


Thanks, Carlos

