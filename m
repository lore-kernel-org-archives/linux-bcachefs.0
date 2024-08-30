Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F1B2F2C
	for <linux-bcachefs@vger.kernel.org>; Fri, 30 Aug 2024 01:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724980792; cv=none; b=DQ2Pd1p31zUtFtIg8FB3k5fiqhUmJysXa+bdsQTjQ0iub/aXTQ2m3NI6znPFUZtQmkWPCh3ZZEbwuMgxJOoaEDuWSGJhTjDCMZvU6xZD+M+fy+QXaeE8fCMAJHf7ejTXoKPYAKNWy6RB6DkCTN5QRrRTwQVzJHC2lCHcHZjTU1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724980792; c=relaxed/simple;
	bh=84ax/uqddWLmhLhq5+lVEDy5FRy/G98Npnk0u1cC44g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NRurPlc27JxDL0Ccsy2Cxh6CGXG2TD5+W5oLl+mrBTPI+cU6ioNIkzhdBlv9zsFNRJwvluKHB6P3Lw3LntFl9/Na8TlplHPDB0TeXv+6c7QuAL1qk0cCo/Iky44WiGd02Bf784sG2uE69W9/NS5jKb39RGPsWwkpm0pg3zXmfwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SSwpIi0T; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SSwpIi0T"
Message-ID: <3d5e6272-1283-4b43-a30c-d5c4fad88946@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724980788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=84ax/uqddWLmhLhq5+lVEDy5FRy/G98Npnk0u1cC44g=;
	b=SSwpIi0T5RSLmHb8+YWQo3yAK5PUy6ve2X0fJ0SR2o/+Wbcgk3qJaZODwMyOwUv+iP+D+/
	h62fzKXBMalpu58fPIAxxW1VSnsJyxobb4htKABs7Er4JOawbVN1gAIVD1P6eNEWFzsdgN
	yBRvhmF9GeDis6oDFm9MXbRU8Pq1obw=
Date: Fri, 30 Aug 2024 09:19:31 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: Remove the handling of bch2_trans_iter_exit()
 in __bch2_bkey_get_iter()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20240823031955.202795-1-youling.tang@linux.dev>
 <f2uohiy7zaaiv33r7xhofaprv6tk5mumvzzf7plvagdtavrini@3orfgcehid7q>
 <f9f50184-364c-4082-bf19-ea953c3c1429@linux.dev>
 <dcutapnlzvglzlbta2tzcvch26g2nnptluykgz5gabcoolxywu@fwq3u7jzd3y2>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <dcutapnlzvglzlbta2tzcvch26g2nnptluykgz5gabcoolxywu@fwq3u7jzd3y2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 2024/8/23 22:51, Kent Overstreet wrote:

> On Fri, Aug 23, 2024 at 02:07:20PM GMT, Youling Tang wrote:
>> On 23/08/2024 11:55, Kent Overstreet wrote:
>>> On Fri, Aug 23, 2024 at 11:19:55AM GMT, Youling Tang wrote:
>>>> From: Youling Tang <tangyouling@kylinos.cn>
>>>>
>>>> - Reduces bkey_err() calls.
>>>> - Avoid redundant calls to bch2_trans_iter_exit() in some functions.
>>> no, a function that returns an error should clean up after itself
>> Yes, functions should self-clean when they fail.
>>
>> However, there are repeated calls to bch2_trans_iter_exit in
>> some functions, take lookup_inode() as an example,
>>
>> When bkey_err(k) returns a non-zero, call bch2_trans_iter_exit()
>> once in bch2_bkey_get_iter(). It is then called again in
>> lookup_inode() via 'goto err'. (We can correct it by simply changing
>> it to 'return ret', but there are many similar cases.)
> I'm aware, but I'm not looking to microoptimize at the expense of making
> the code more fragile and less clear, especially right now when the
> priority is stabilizing and fixing bugs.
>
> If you were also doing performance testing and could show that it
> makes a measurable difference I'd consider it. Did you even look at the
> assembly output for any of these functions? CSE might be optimizing away
> the redundant calls.
I haven't performed the corresponding performance testing. Looking at
the assembly code, taking `lookup_inode()` as an example,

Before the patch,
     142f:       74 96 je     13c7 <lookup_inode+0x117>
     1431:       48 8d b5 68 ff ff ff lea    -0x98(%rbp),%rsi
     1438:       4c 89 e7 mov    %r12,%rdi
     143b:       e8 00 00 00 00 call   1440 <lookup_inode+0x190>
     1440:       eb b4 jmp    13f6 <lookup_inode+0x146>
     1442:       e8 00 00 00 00 call   1447 <lookup_inode+0x197>
     1447:       66 0f 1f 84 00 00 00 nopw   0x0(%rax,%rax,1)
     144e:       00 00

After,
     111f:       74 96 je     10b7 <lookup_inode+0x117>
     1121:       eb c3 jmp    10e6 <lookup_inode+0x146>
     1123:       e8 00 00 00 00 call   1128 <lookup_inode+0x188>
     1128:       0f 1f 84 00 00 00 00 nopl   0x0(%rax,%rax,1)
     112f:       00

The following three assembly instructions have been reduced,
     1431:       48 8d b5 68 ff ff ff lea    -0x98(%rbp),%rsi
     1438:       4c 89 e7 mov    %r12,%rdi
     143b:       e8 00 00 00 00 call   1440 <lookup_inode+0x190>
