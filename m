Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4788195B1A;
	Thu, 31 Jul 2025 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753987970; cv=none; b=BuD6WQNRUn2Uf8fcOkqlZlJ0dZyRt5fpi5+eioPs5ncdTAgpORD/k/wejtmxIYgtfoGVV/xQecj5pKH9Be4TFt4Qqmsuu96ruWZOOAi+i77YK73Y4nYiyA36K3jBE79gk0lzJTKOJ3uyGvijZl/e8vtyu9lzMapiDLwmP6sJpb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753987970; c=relaxed/simple;
	bh=XYNRSN8ZAF6ndKtJ+piuSB6Y/ZKeoVVvznszHhDfw5k=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=HdPP437FMdOrcf66reN3Y3eUqg2y8G1LcNlJ+Cm5d/R1pJamchST1LSmyV3McvmqJxd9UuaGDsxAxPNdsT3hn0ogs52xcVU2GWfCIolZ4yHJX/CBaQw6URz4Sg3EuLMXTplsn2ZrROsCfoWtpaO65Z2eCOI0LLSPF8z8/72fA4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=CIZ8K+/8; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="CIZ8K+/8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1753987966; x=1754592766; i=markus.elfring@web.de;
	bh=XYNRSN8ZAF6ndKtJ+piuSB6Y/ZKeoVVvznszHhDfw5k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CIZ8K+/8mRauci8seUVmwUksqFDTsabNwg4gWZeRgwoJf+T7MfnVpDJ7T2Bu+lo7
	 7ymvTTL5kv1/PINe/+y45PQPNI3Wm0Uxgc/n8o2BKSa7j9p6mNFD8Q+FN8bBZR6X1
	 AXAMI0umAXMCd8w25FyhNrttWyiwNnK49OjkmvV649NjRFqiMPh8pPBsXVcjZhaa3
	 CaNQYPrXDoGlcNpmiDpQFw+X1N80wa5bgljqF40lSvY3Q2C2GV9/geDaFrm127s61
	 +KCB8IyKaETUTNG+lB1ULnjdDvRUxPbdfRy6WMXmy0p/bQcxF8cis3wS15DeyXcwW
	 0FqFQaE54Mcv9hyTaQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.235]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Md6xz-1u7OIQ2FYR-00osou; Thu, 31
 Jul 2025 20:52:45 +0200
Message-ID: <32fbb160-4888-4d57-bd16-62ece192e81c@web.de>
Date: Thu, 31 Jul 2025 20:52:44 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Liao Yuanhong <liaoyuanhong@vivo.com>, linux-bcachefs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <20250731131551.218666-1-liaoyuanhong@vivo.com>
Subject: Re: [PATCH] bcachefs: Simplify kzalloc usage
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250731131551.218666-1-liaoyuanhong@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NpvGVBd5ZMr+IoJMcg9HTuyM7OwtSr/ipi1k5r3xbq8o5QGCspo
 3q/lJPha/qGrtlA4ga0wG4NsdDaStzDKuntkmbi+73AvesPx8VltwqQ6++AKcfYV48cXE19
 6rkcBLGk/5wV6C2kF6xbUDJC1YAedpGl/w+HsYaWAz4xbAenwYxJxFutUgvEol8JDLYuVjR
 b5onKVgiQqJYsezeFHftg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:y8wHb4tWxTI=;G4OpS2e6AY1x2UL4vTi4VGgAW+l
 XbljTdO1NDeP7+Fnbrc2MX1sfPYDLIg8OS3FuUzx4CUfDFfW9EGKOF1U2aq5VzyFKRG/C6CFm
 ziqD3vGEtMyAAGjMWCce6J1IFjP7QG4+FnD3JqOi4jXWumFgPR/ONv9IzQVaW2+A/nYPghDA3
 1hWcIWNqjWsUfkOXIdcjZe6Nbxs88K2GV223LDToobcwFeOlbpwK01pZ0ppCDYwO9p5YyxUH7
 af0HB7lX3NBX0Kd0BWrr0uO8T6zBBymM/7MrK0EfSqvZDglH8Yj/T1OKc5RQyjza3vFf0aNcc
 cPAAW7zPxPZz3TAUyDCOrOz/rznSRe3r2hRrA7kEBKcujyUp8+53ky9P3Mlm3EKKIkkwUjJcm
 iFoWlomhRlF3kFVX3qPkcP3BEoX69tXN9M2PDJ8pyEolv2GiAHBWVbr62uiGmB8YBgiTGXcRr
 uEmlCVdCVCFJK/+ixiaF9uG7+1WClBFbyuY2DAnPyN2AMMsp6dJgnPQ3JCVeLe3BZWLJGWGn5
 yzuu4LdPLT6uLy/FwysTChSGceUlRnynliecuaZUZZO/Z8fCpMz9aB5KGhJ5lL9nHRgn5JGOM
 3DnSdYolGS9E71ppEkmEXOBCmrHPiwRp1+tFUzlB7nYvM1Jg6Ca6tRoasUKcdD8gZJGd3e0OR
 LeceIVH8MGufHl4W8vlwlrqFkrPFj7rPhHJG+gFwzZd+geZN9eNoTTCN2A8aQiE0Q+sN4YjtM
 RfId26l+LVE++HzX+bQy309CN//M3fWKXEqF8zN445QveLTkB2gpDMtgu2tSB4ZIzGqu30fp4
 B4wZ2zb935jHmVz491iG+B0b67uPbc3Zrd8Ufn5pd3YBAY/X5N3PlL/DQsyU0p5OkgQ/qfMYe
 HShwLzJqwmNbnNfcfGpc+5KN7AbtaC+jPxTHPxfxLXqatnJyFBx6hqSJLTlnHOmVX7bmO86CQ
 X60Bbz4Yp3ww/JFKaOS1TCf0wtQ85BgCWdSE4rO2luEcPAsEBuXCYcvEyT4KujTFwgzObiNHQ
 OGxlS+6pXJtFDS3hEu0W1NW2WLRR/ezj4DFNu5Xju1SCbn7sXIBGjQgc8Cb3HqbjNM6XerBJc
 9YsvXPe4WneTIqFtRht0jZcrw1oJMDnZ6iSJp89JLssk2ZU/XIy//RxbuZCcJu01uNwdWXHCP
 LsKXzoyo/WSurfqTHcQhaOtonibYg2XaiLksGxv9BBeDsSP0YUxyjKc/zsfu0KOWPyQZqidAn
 qnbuc5d1RG5bXG+/ZWbi4AugJJ0aEl1PGmuw/5AJt5zxNhWHZfigY3y2gV6680I4fDgE4hXsz
 7UqqTYueTpJxPRvwuIL9YrqhpK84DI2uX8T8dLtn65sJYcn/g0FX79JzjIQWP9CCneWPurysP
 7oWsAIwclw7Tp0Kfksr5nUFAoYRLPgXWSeQCMolAkXvWHymjyp6mC8fqgou1IN6hONTqtcpWz
 htG6WRWXt/xHUTYmJTs+m+FHLbpGE3244qKMLJpKcsatiy5T8awz/fzI1UmlDrRjzh6MdJ3jx
 bFVqL1ZzMEQoUmfqzlMtU5ZE/GwY3o0kFk4arhOPuKztfEupywF6UZIYIFef9rOoOlKMavgd3
 F2QMnDWquxK42lM0SeqTaVMQBSIvZwzej0jx4b8NNyokjM0GUg88LbeiGzX/D9b0T92aIblyR
 NueHR/kiU1tbFCNB9sBEzubXpaqCFfpV0UsR8lKPYL2sFz/yqDv4pNxOC2C56/GqOFXXc5xPI
 4oZFwBMxEBYSOoTZsWJdqmUVVihqNfn1w34dDCzuh/fzMFyPqjAl5Z5M+heq0A1oaeaJTS2za
 4p0gIjig31TIHVfZfHqphzAvIPpMWZGPYkZs5GPpiEjH07zOzTcUXc1ruhKgI9YfBcE9Kd7Um
 cK9kkxB7ZuY9LCY1WlGz4xLWj2ndxf3w1Xtq4Ya3rIpWHv87EqdNlq0hjduiIUMT1C5+gZRva
 9BDu1SFUzajBtVn0w8ch5+i4gSZqxKCghDV1tzU+4EKg5whkD89uUrEZaNlrwmUpPa1T/A2vf
 h25ibDkjyHC2C6zgftpTLXVqPAIRRncrJvWlVffg9kKunM1kiIqspencqxUjcWQtNtY9YtH6e
 wZxiKrrj3Y88+QDra7gC51bVRnR6PcUtzTdJQYpfa2OuR7qIShsXxwdrnzYID/OZNSks4gwHN
 R0oYOCLrT1+URJPJc7vam4H1oj7wyj+yJm0yu5CbmjTE9ng/+ZjqdhCZHvQme4QM4kJnFYYt7
 8RvC/w7lsGETAKi1cMyt0nGQCybFrST1YEhrSpDzhsGwdkoGcCo1VsHZ0hr0AWWdLU1hc34fV
 Nms+urnRsB0QokSVbFs+PYS0HP3EhU5WMrYDExBJotLWts74FrLieeHjXz7dBtA5iqc95TaJ8
 ojAqqdpIpVfNYC3P11M2mVM8jrulgTaYHxgVwco9TZlojJKVHbhNmQtDqQS+pb/fktV/4oTBY
 tdu9J0RrXaqWK/Vj02Ay/ilmpdVOwwVt4xGZDkARu9WyjJVYbeVs3ZRKdqSbuhavO+Jy1HLcQ
 047IimLOp1DfODgKcmlf5nYfCAFZkhCYZbYwa2aSgCXOLI0ZFzKqKSE/0ARXoOLxCyZ/ECoPS
 7XKQipXNsZ5e3G7k6DBT08Kc3xWeJnbuSmfPVBDnhTlwqGVJHh0p/hsT7uFIX30mqyviG0lEk
 HVbq3l84dqtgHkwmpTuY0nvCkFtJPb6yVEsUb8E7zIZh9uJPXg5xqbN+RyGYXWan0oC0lk+o1
 zrIB95GSBy4F1CVzYypZpNavON+jqbNvv4vXXsshkN1+zO+CRK7IlEwCPocJfIYVGn+IfUI/s
 KNQSkx+D7Yhgr/kKCumb0JiaFxKXXE3UBCVaIhm6/MnLyiKI9SZKFGZT41/QjpxpRxCbRmmm5
 vawt+zA7wphLNSQIuh/epJx9duQQQWg6TKsJG9TFUYOKR7a7LKo15X7kSjMTuBwW/ASvbtMCx
 mmvvegZ+n1koa34g748sY8IPvLd10b5QGY0/49U9o7uesebSBE1bof+kNPfALfHyaZalt3SwX
 5jNbwPf/re4mIYGWGALTk+2AG14yGCQujpzpM3JZtCxlqYmMRtad4Yo+mXzDAHiihwy8xAgk2
 ZAh9v9tRG5dB08B+gG+haJgA7yMEEDxBVCk+ET1V1TF+W5l4ndw53im/1b1ghx1+gm4sxgPxC
 ky9+xoPOG5m4sJZKR1HS4dV9+qHFaA9yJzBGsY2AXKdQgF9DHiYfVfGz6Nm9ZSmORxBpKwWx5
 3EvS3UP3pLQloc6tr/BjIYqvII+Uy4NcGgVfawe1uDEXQar1rg63wIN0cTI8jBaO1MgMZ/MYg
 eZr+x70AUvy84S2SdNBEsjoo5pHdDOfIYb5QAKAUAqeCqH3oMzhW07qhkmq7xOdhKDz+p9QPt
 EK5JTlrsTbbccPPA3VWEfW2Fzt+O6eeGkIpvhoHwFbOQAvSuTsK2pm0kofF4wYSq0GI6UuwW/
 pl1A2XCweP6mPklfPc7c3Bndal0q/zu1hgpbtDtHQ9ymPVDgYDsRNO4ZNknvVqhD7O2fvCpgT
 Wg==

> Use the shorter variants will improves further maintainability.=20
> Convenient for subsequent code updates or refactoring.

Please improve such a change description.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.16#n45
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.16#n941

Regards,
Markus
