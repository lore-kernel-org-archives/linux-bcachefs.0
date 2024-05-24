Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07012CD8E;
	Fri, 24 May 2024 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716566617; cv=none; b=OoBfrQPl1HPwzpNODdw6y4F9plLRZML5n4mi3+6h9maL3ZMd9DEwxQbUafDIm3iDml6gK36sUKDemWZ9QturopKk0ZWz3OuWzcfuHxfDZ1XvkUXePgGUMianLdwVEeZcio+L4skBP5yM3/D1Mh2DaM9ESGEm19F2RCl4FPVJJoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716566617; c=relaxed/simple;
	bh=jcYfrQux9RRufLBucVlaKQB/uSKaLAyTFQ1XBs3s/18=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XfdMyN5zPYjg/Ff2gP78JOOSdW1y/lM6jq1dCd2Ptt9lmsG6OHXGSwjSjBYqoFoeoG2noQRYG07udU2ry9DVagiWKAsi2CMz0gdEgLey+mKZw/GTF1p7dlo/y5kD7hvF47bZNVMldl7uJ3udzvblb++LlmsWXyugzcZZePQHG/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=BJ7hrmY5; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="BJ7hrmY5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1716566614;
	bh=jcYfrQux9RRufLBucVlaKQB/uSKaLAyTFQ1XBs3s/18=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=BJ7hrmY59qdh4O56NrMB5x+iWZR9T0WcUGf+f5D2Qo1Qw19wz6478UWqyrAGio8DP
	 mQEU+sP+FBbdlnJAfRATwFkavyzQCgs35Yp21eb6Jsim6U9ChpnTWW8+GP19t6R6kj
	 rtFeaNirDP+bY9EklkVzOlx0zHqwzMIJP+oTRLgY/2XuXebBeXM339WxVjmFYrcJ4H
	 JxaTU7wOyqq5fVqRuCarRi1DRem1L3MIPCVA7dFFyd22m+FHHEx9eyLHNV3SSr5Bi2
	 L+kBaonsDvKf+zzG2nB/eISphTs8fAQByHO4wCW7LvT7eAB6H12SXlxd3i5ZoWoPgr
	 1Yl7mbE5VnmFg==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4Vm8wQ4q9Dz11J8;
	Fri, 24 May 2024 12:03:34 -0400 (EDT)
Message-ID: <7236a148-c513-4053-9778-0bce6657e358@efficios.com>
Date: Fri, 24 May 2024 12:04:11 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Use of zero-length arrays in bcachefs structures inner fields
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
 <944d79b5-177d-43ea-a130-25bd62fc787f@efficios.com>
Content-Language: en-US
In-Reply-To: <944d79b5-177d-43ea-a130-25bd62fc787f@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024-05-24 11:35, Mathieu Desnoyers wrote:
> [ Adding clang/llvm and KMSAN maintainers/reviewers in CC. ]
> 
> On 2024-05-24 11:28, Kent Overstreet wrote:
>> On Thu, May 23, 2024 at 01:53:42PM -0400, Mathieu Desnoyers wrote:
>>> Hi Kent,
>>>
>>> Looking around in the bcachefs code for possible causes of this KMSAN
>>> bug report:
>>>
>>> https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@google.com/
>>>
>>> I notice the following pattern in the bcachefs structures: zero-length
>>> arrays members are inserted in structures (not always at the end),
>>> seemingly to achieve a result similar to what could be done with a
>>> union:
>>>
>>> fs/bcachefs/bcachefs_format.h:
>>>
>>> struct bkey_packed {
>>>          __u64           _data[0];
>>>
>>>          /* Size of combined key and value, in u64s */
>>>          __u8            u64s;
>>> [...]
>>> };
>>>
>>> likewise:
>>>
>>> struct bkey_i {
>>>          __u64                   _data[0];
>>>
>>>          struct bkey     k;
>>>          struct bch_val  v;
>>> };
>>>
>>> (and there are many more examples of this pattern in bcachefs)
>>>
>>> AFAIK, the C11 standard states that array declarator constant expression
>>>
>>> Effectively, we can verify that this code triggers an undefined behavior
>>> with:
>>>
>>> #include <stdio.h>
>>>
>>> struct z {
>>>          int x[0];
>>>          int y;
>>>          int z;
>>> } __attribute__((packed));
>>>
>>> int main(void)
>>> {
>>>          struct z a;
>>>
>>>          a.y = 1;
>>>          printf("%d\n", a.x[0]);
>>> }
>>> delimited by [ ] shall have a value greater than zero.
>>
>> Yet another example of the C people going absolutely nutty with
>> everything being undefined. Look, this isn't ok, we need to get work
>> done, and I've already wasted entirely too much time on ZLA vs. flex
>> array member nonsense.
>>
>> There's a bunch of legit uses for zero length arrays, and your example,
>> where we're not even _assigning_ to x, is just batshit. Someone needs to
>> get his head examined.

Notice how a.y is first set to 1, then a.x[0] is loaded, expecting to
alias with a.y.

This is the same aliasing pattern found in bcachefs, for instance here:

bcachefs_format.h:

struct jset {
[...]
         __u8                    encrypted_start[0];

         __le16                  _read_clock; /* no longer used */
         __le16                  _write_clock;

         /* Sequence number of oldest dirty journal entry */
         __le64                  last_seq;


         struct jset_entry       start[0];
         __u64                   _data[];
} __packed __aligned(8);

where struct jset last_seq field is set by jset_validate():

		jset->last_seq = jset->seq;

and where journal_read_bucket() uses the encrypted_start member as input:

                 ret = bch2_encrypt(c, JSET_CSUM_TYPE(j), journal_nonce(j),
                              j->encrypted_start,
                              vstruct_end(j) - (void *) j->encrypted_start);

Regards,

Mathieu


>>
>>> So I wonder if the issue reported by KMSAN could be caused by this
>>> pattern ?
>>
>> Possibly; the KMSAN errors I've been looking at do look suspicious. But
>> it sounds like we need a real fix that involves defining proper
>> semantics, not compiler folks giving up and saying 'aiee!'.
>>
>> IOW, clang/KMSAN are broken if they simply choke on a zero length array
>> being present.
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

