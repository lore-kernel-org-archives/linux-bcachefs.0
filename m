Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE412EBD7;
	Fri, 24 May 2024 15:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564896; cv=none; b=FhuVB9lWsunn0aNgmu/5MauL/5G6rhe6npDJW0+9iHorkI+HIa5TT91GkfB1IorMmn8xQoP22fbVItRI4Cggl7Itlg4eusbwmyCDxyNaxOjYWX0ck87aLunO5bSiMiboXfl2I6TKuBAtq1jeW5qQZXCFtjPwVU4ZYI3imzkNQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564896; c=relaxed/simple;
	bh=YIHADUrzMeqDU2GX2RwQe7hbZm7SQ084SaTkE+z+/Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g6DGx6hxFsQkqBmuYjcgjvlSfIJhQoMHsoxU4hIEd47zbotdLYBM+4WBz9Jv9hxNCRTeVyEm/MC8CK4nkG6J/Dut7ehTjPA6Q48ixdRFC4QDh55qtvh40npPF3562jOuZPtsNMMFLgKSmMcYIl8FA0gqpzMqjoledOJQlKg7XT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=OpuW54cR; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="OpuW54cR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1716564886;
	bh=YIHADUrzMeqDU2GX2RwQe7hbZm7SQ084SaTkE+z+/Rg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OpuW54cRF0EDUvqWAD82RynvJZvRgCkM6tPI2OSk0XYy4SxCyCU6PBDMb4v4O8xA/
	 d2hyTpY1pgJl+7nY2Svaix6zOj17b3ZRTDlNCrVqIWQjLZqA0MeWV8HuV3bmFZzgEk
	 Fxj89UHxyfsk8aHqW2e3SL6K23dzwz/SxcoTa2xlETbulOnj41XZCp/CXruzpVObyh
	 k5Mdx7AzCcG7eKrWLUoQ/ZdiTP7Jy/ZP4v/TU2dzGHf1XU9cLXV2e8WJVF6K6sO18X
	 LGwLBxXYarIzxfD56bKvbOcw88CLPAIGZnFHzGk4EJ+thEJ42R26HKVPg6cl22Z4Ff
	 CV9HfLbWAGlcQ==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4Vm8HB0VZNz1174;
	Fri, 24 May 2024 11:34:46 -0400 (EDT)
Message-ID: <944d79b5-177d-43ea-a130-25bd62fc787f@efficios.com>
Date: Fri, 24 May 2024 11:35:21 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Use of zero-length arrays in bcachefs structures inner fields
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, Kees Cook <keescook@chromium.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, linux-bcachefs@vger.kernel.org,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 llvm@lists.linux.dev
References: <986294ee-8bb1-4bf4-9f23-2bc25dbad561@efficios.com>
 <vu7w6if47tv3kwnbbbsdchu3wpsbkqlvlkvewtvjx5hkq57fya@rgl6bp33eizt>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <vu7w6if47tv3kwnbbbsdchu3wpsbkqlvlkvewtvjx5hkq57fya@rgl6bp33eizt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[ Adding clang/llvm and KMSAN maintainers/reviewers in CC. ]

On 2024-05-24 11:28, Kent Overstreet wrote:
> On Thu, May 23, 2024 at 01:53:42PM -0400, Mathieu Desnoyers wrote:
>> Hi Kent,
>>
>> Looking around in the bcachefs code for possible causes of this KMSAN
>> bug report:
>>
>> https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@google.com/
>>
>> I notice the following pattern in the bcachefs structures: zero-length
>> arrays members are inserted in structures (not always at the end),
>> seemingly to achieve a result similar to what could be done with a
>> union:
>>
>> fs/bcachefs/bcachefs_format.h:
>>
>> struct bkey_packed {
>>          __u64           _data[0];
>>
>>          /* Size of combined key and value, in u64s */
>>          __u8            u64s;
>> [...]
>> };
>>
>> likewise:
>>
>> struct bkey_i {
>>          __u64                   _data[0];
>>
>>          struct bkey     k;
>>          struct bch_val  v;
>> };
>>
>> (and there are many more examples of this pattern in bcachefs)
>>
>> AFAIK, the C11 standard states that array declarator constant expression
>>
>> Effectively, we can verify that this code triggers an undefined behavior
>> with:
>>
>> #include <stdio.h>
>>
>> struct z {
>>          int x[0];
>>          int y;
>>          int z;
>> } __attribute__((packed));
>>
>> int main(void)
>> {
>>          struct z a;
>>
>>          a.y = 1;
>>          printf("%d\n", a.x[0]);
>> }
>> delimited by [ ] shall have a value greater than zero.
> 
> Yet another example of the C people going absolutely nutty with
> everything being undefined. Look, this isn't ok, we need to get work
> done, and I've already wasted entirely too much time on ZLA vs. flex
> array member nonsense.
> 
> There's a bunch of legit uses for zero length arrays, and your example,
> where we're not even _assigning_ to x, is just batshit. Someone needs to
> get his head examined.
> 
>> So I wonder if the issue reported by KMSAN could be caused by this
>> pattern ?
> 
> Possibly; the KMSAN errors I've been looking at do look suspicious. But
> it sounds like we need a real fix that involves defining proper
> semantics, not compiler folks giving up and saying 'aiee!'.
> 
> IOW, clang/KMSAN are broken if they simply choke on a zero length array
> being present.

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

