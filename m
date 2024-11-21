Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779101CC885
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Nov 2024 23:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732233233; cv=none; b=D4371UbypQTOND895Cpo11perRazRdU72t7Ev5wsdBCnVRP8I8v3ESoQ3EdkFJyeHcrcYJUIrdbhVqqM6xy9Nlym3BMBsWkyuVVKFRnO9gGaIufsqddbg8cTa91OlkD3pdFG3rbUDbcCbVAcHM+RwbLkGm+Fb7aaaqvWIO0SvHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732233233; c=relaxed/simple;
	bh=j8HtVc2jXBan6FbqE277Xt6/3C49W0fYTo4fzxzIsb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SHKMKY7Dka+ZvkwjgfSqHKcVM03xvJI3cp077i+QkzgUxJV3A3fceEfQ7XUkG4+brcs6NyOI/994QlsDHFpq991slzbcqMRdvhK4AQZqJtuRDE4FkXogWD1nvwu+fYzR6WUDNqgrDBbOS1g2u1jL+NKyOh+6eqcmUFwRS44tPXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zepq4qXS; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zepq4qXS"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83abe7fc77eso57877139f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 21 Nov 2024 15:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1732233230; x=1732838030; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ljvFTLckgMBXyc/hCWJm3TmPmL56Vi1djSJCVHusK+0=;
        b=Zepq4qXS4bnFi4qOXhrW+Tdl6Bs9VtX8EKZEdpU8FGyHf0F/IwzVsKarg0m4q3LHCx
         rhFC2JhI5GH9RFGKa6xZWRv6Xqo9KV5LMenF7UcIodxREy6axtFlmWRzmrsa8CJ0xWWY
         q4fIhhe+FknbBqFgdtcEBOQfDpCQcP3zW9vk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732233230; x=1732838030;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljvFTLckgMBXyc/hCWJm3TmPmL56Vi1djSJCVHusK+0=;
        b=INd3XMBv+wrAsDUYKIfhTk9i/HuBD5Zg447wBPU3AWs4Ukfvn0Tq5qs9E3u9fIJaiA
         W1dKnnJfD1qAaxPMZBzYgv64DXjuBogDPGv6sg+JV0iCoqWeTRwO9wotW5/Tw+3hcDnk
         brgzlo6DLYXfM4RCoUqFZSg3UCKU+bh5pNfLuoUlo5Mua/MKD/3blA7pZnQDaD8Fiwo8
         5CsGioUpx9vVIIvgYIr7yqq3YkhXG/8Bh7XvbWTHfoT31iqEtIxlhrd44qVq0SayP5bL
         ISnVnpnNEnc3RdgftjFYR/nelxY9ngGirjadPyZNlrUcMkAzo2cwcoM8yIPNZIrwLcti
         lIsg==
X-Forwarded-Encrypted: i=1; AJvYcCXMZBPFgshH40noZV/6+2Hx4koIno3DU0XKeR0e5CP+NNMBZUDrrKzVdmXyt+n9F1EmidkHwxAQvOQIhe225Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyte938n3AShQdEiG4s2BLSJfInhDp9i2eMtqPSharfRED1WtiY
	EOgUtBRDlGZVMFfPv7uDiELCWRdQ1WM/7v1t8n7MwPQ2ceaSagP07mgFkhKIZtQ=
X-Gm-Gg: ASbGnctWGyrDSA6pJBBdamdY+eKlM0wSfAwr4n55EAUkxnpoxocmtba4/QdOAeD+rQ7
	u/L7gZc6sFql0blErQ4iyTgMpgvKG8vCmtkq23uPav9PP3XjMLT4W8ptHBIXlxV5IribwAiStsz
	HlChrY7Xat/yRjj3J3IUnnqBP905Z2+HXjFlXUsO2FkmWNAZoXMnBFAlbkUTslTQaQbCm6fL4Qn
	H33Aq/38qjhPtsEmRiJV+78NwMMwtIO98QpmhitPEGw+mvJAyV88rReNX4D9Q==
X-Google-Smtp-Source: AGHT+IF96MGQRTP0elvAz6sBTHwpiq8D9SyOiWFimZgfz4bG069DfMpMT/a7a5sO+nbaJTtWXJBa8g==
X-Received: by 2002:a05:6602:6405:b0:837:7e21:1688 with SMTP id ca18e2360f4ac-83ecdcf315cmr96081939f.11.1732233230456;
        Thu, 21 Nov 2024 15:53:50 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e1cfe19f0fsm359847173.12.2024.11.21.15.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 15:53:49 -0800 (PST)
Message-ID: <39e8f416-d136-4307-989a-361bf729e688@linuxfoundation.org>
Date: Thu, 21 Nov 2024 16:53:48 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2 v2] bcachefs: do not use PF_MEMALLOC_NORECLAIM
To: Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>,
 Andrew Morton <akpm@linux-foundation.org>, Yafang Shao
 <laoar.shao@gmail.com>, jack@suse.cz, Christian Brauner
 <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-bcachefs@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 "conduct@kernel.org" <conduct@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <citv2v6f33hoidq75xd2spaqxf7nl5wbmmzma4wgmrwpoqidhj@k453tmq7vdrk>
 <22a3da3d-6bca-48c6-a36f-382feb999374@linuxfoundation.org>
 <vvulqfvftctokjzy3ookgmx2ja73uuekvby3xcc2quvptudw7e@7qj4gyaw2zfo>
 <71b51954-15ba-4e73-baea-584463d43a5c@linuxfoundation.org>
 <cl6nyxgqccx7xfmrohy56h3k5gnvtdin5azgscrsclkp6c3ko7@hg6wt2zdqkd3>
 <9efc2edf-c6d6-494d-b1bf-64883298150a@linuxfoundation.org>
 <be7f4c32-413e-4154-abe3-8b87047b5faa@linuxfoundation.org>
 <nu6cezr5ilc6vm65l33hrsz5tyjg5yu6n22tteqvx6fewjxqgq@biklf3aqlook>
 <v2ur4jcqvjc4cqdbllij5gh6inlsxp3vmyswyhhjiv6m6nerxq@mrekyulqghv2>
 <20241120234759.GA3707860@mit.edu> <20241121042558.GA20176@lst.de>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241121042558.GA20176@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 21:25, Christoph Hellwig wrote:
> On Wed, Nov 20, 2024 at 03:47:59PM -0800, Theodore Ts'o wrote:
>> On Wed, Nov 20, 2024 at 05:55:03PM -0500, Kent Overstreet wrote:
>>> Shuah, would you be willing to entertain the notion of modifying your...
>>
>> Kent, I'd like to gently remind you that Shuah is not speaking in her
>> personal capacity, but as a representative of the Code of Conduct
>> Committee[1], as she has noted in her signature.  The Code of Conduct
>> Committee is appointed by, and reports to, the TAB[2], which is an
>> elected body composed of kernel developers and maintainers.
> 
> FYI, without taking any stance on the issue under debate here, I find the
> language used by Shuah on behalf of the Code of Conduct committee
> extremely patronising and passive aggressive.  This might be because I
> do not have an American academic class background, but I would suggest
> that the code of conduct committee should educate itself about
> communicating without projecting this implicit cultural and class bias
> so blatantly.

I tend to use formal style when I speak on behalf of the Code of Conduct
committee. I would label it as very formal bordering on pedantic.
  
Would you prefer less formal style in the CoC communication?

I am open to educating myself.

thanks,
-- Shuah


