Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E982628D;
	Thu, 23 May 2024 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716486793; cv=none; b=QtmpQU1IE7XkfDi9PeAfEaWvjHoY044pn9MsE8wmiv1IIpaBnQq/yhv+5jtdRSNaLugfYmkuP2qjL7K1/chKKGBd45/zZmYe6s/u4lNuznJ26nKkbblkID2wVZbUgKszfJz94ekntX7/KZz+HXvVCAbRY4zE9TW/1GT6DdFdbGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716486793; c=relaxed/simple;
	bh=eG8U1x4QQ6oumcc1cnDrsvXG+P8ChtqXaLkve5TzQPw=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=i0aS7XXVOmz2Nc1kLEPqxNeUk4TR7w6MsWemoCEY7ZSzWtUGtnrLo6sn2Qh61Rdpq48z/aJn+LsuCkA1CqaPzB8EGcOErbAgqfRaWfUMT0Lcg/n7A2lCjIeNC6ZCcRP8QG3yiLZnmoFBoVOiApBZM0qHo8uQJQKsyrpha3p1B+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=ARJFYZmC; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="ARJFYZmC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1716486786;
	bh=eG8U1x4QQ6oumcc1cnDrsvXG+P8ChtqXaLkve5TzQPw=;
	h=Date:From:To:Cc:Subject:From;
	b=ARJFYZmCYbAkdCd3p5z/igjCc7ZkAZOOSs8k71Th+r0zrlLrf4DRoQpinm8YM6vwg
	 8QhNU0Pi00NDZj6vqTRVwSne3OYf62I8v7GNaHbSipEvxKwX59C8ZdrNXHEzErUl3+
	 oHVj42XQCDW8zud5eT7I3reyqfKoOy78zv5zuD+spLbToK5w+zQbZGEh1hYBoqq4kQ
	 I94qF6TZADNmYhpn0hbOTpuuoGgHQSSGgQX30Q3Qb7mSttRLZ0JTDtE4+Ez1b/KS4D
	 UWI8V4V9QrArEg4YgKEEC7n55DKvkI2M3FktTlBGkQXvgBSHO6kaZr1AwqTp+W9+C4
	 0YPOjOrYM+G2A==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4VlbPG3fBRz116b;
	Thu, 23 May 2024 13:53:06 -0400 (EDT)
Message-ID: <986294ee-8bb1-4bf4-9f23-2bc25dbad561@efficios.com>
Date: Thu, 23 May 2024 13:53:42 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Brian Foster <bfoster@redhat.com>
Cc: Kees Cook <keescook@chromium.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, linux-bcachefs@vger.kernel.org
Subject: Use of zero-length arrays in bcachefs structures inner fields
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Kent,

Looking around in the bcachefs code for possible causes of this KMSAN
bug report:

https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@google.com/

I notice the following pattern in the bcachefs structures: zero-length
arrays members are inserted in structures (not always at the end),
seemingly to achieve a result similar to what could be done with a
union:

fs/bcachefs/bcachefs_format.h:

struct bkey_packed {
         __u64           _data[0];

         /* Size of combined key and value, in u64s */
         __u8            u64s;
[...]
};

likewise:

struct bkey_i {
         __u64                   _data[0];

         struct bkey     k;
         struct bch_val  v;
};

(and there are many more examples of this pattern in bcachefs)

AFAIK, the C11 standard states that array declarator constant expression
delimited by [ ] shall have a value greater than zero.

Effectively, we can verify that this code triggers an undefined behavior
with:

#include <stdio.h>

struct z {
         int x[0];
         int y;
         int z;
} __attribute__((packed));

int main(void)
{
         struct z a;

         a.y = 1;
         printf("%d\n", a.x[0]);
}

clang-15 -fsanitize=undefined -o a a.c
./a
a.c:14:17: runtime error: index 0 out of bounds for type 'int[0]'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior a.c:14:17 in
1

Also, gcc warns that ISO C forbids zero-size arrays when compiling
with -pedantic:

gcc -std=c11 -pedantic -o a a.c
a.c:4:13: warning: ISO C forbids zero-size array ‘x’ [-Wpedantic]
     4 |         int x[0];

And clang states that this is only supported as an extension, even though
accessing it seems to be classified as an undefined behavior by UBSAN.

clang-15 -std=c11 -pedantic -o a a.c
a.c:4:8: warning: zero size arrays are an extension [-Wzero-length-array]
         int x[0];

So I wonder if the issue reported by KMSAN could be caused by this
pattern ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
