Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FEDAEADB;
	Thu, 10 Oct 2024 03:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728531070; cv=none; b=Ag8DzHCaFe1s4m3dzj9x+6RnaO5FM4lrNdZs9tY1ViGgtzjp3jMRFcvojPIVx9TQRGwY18vQCwzp9F8pAYN2fcT51NeflRVUe2dIp1/ZXgSpIYYWx2Gbrhs1grZLPyAPcXDX5zVJzHzm00wGRq58xNfOJMChIn3iDnfUs91rqcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728531070; c=relaxed/simple;
	bh=cI3gZfmnO6lrmjTPRn/r5hs5TIwClaxMTrxlgM1qn3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iuXCc1QXQ5s7Cw0pQnuwzOKi290hmqEuyQ0UPDuQy989jt8R4zzhs8jZSOEZBf55kXpLBNhzBEjvUR6SnqeRoTcJ2PThdneLJmXUDejKs2HGLE9PDCJKUJIFxFxWA46bfwX7kJWQvQAfqKjjaOS5I28yeQlTk62OQsKCzoEv6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=FqD/ih4P; arc=none smtp.client-ip=117.135.210.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="FqD/ih4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=bXB3SM1ZuD48BbMzpkl68tTPLNXx4WWpu2BEvs1/aE8=;
	b=FqD/ih4PJ8p/1DHMG5sLUKKOskNzHZikM9h9aWrfYc1yxoKz2+1fdlPXG0J5NZ
	6609zSzyplRVjarU2yicYiCxX2t0pEjuqKmr9ZjThIb79s4MmfvgzoW7919/R0JH
	czulVfSIwTPmN+so0JM1ftqohRta6YqC267C7DSxCq11Q=
Received: from [192.168.109.86] (unknown [1.198.30.91])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3_7ttSgdnWiw2AA--.59247S2;
	Thu, 10 Oct 2024 11:30:54 +0800 (CST)
Message-ID: <2316ec09-8cf3-4197-8cea-ba156a4a792b@126.com>
Date: Thu, 10 Oct 2024 11:30:53 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcachefs: Fix shift-out-of-bounds in
 bch2_stripe_to_text
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: zhaomengmeng@kylinos.cn, lihongbo22@huawei.com,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241009140755.725629-1-zhaomzhao@126.com>
 <jvqgq5ekxbeims7qolka5xewgwwsdo5okkxvjfkbyenr6rk2r3@qbrg2klzzutp>
From: Zhao Mengmeng <zhaomzhao@126.com>
In-Reply-To: <jvqgq5ekxbeims7qolka5xewgwwsdo5okkxvjfkbyenr6rk2r3@qbrg2klzzutp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3_7ttSgdnWiw2AA--.59247S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWDJrykur1ruw1rKryUZFb_yoW8ZF4Dp3
	yfK3W2yFWvgr42yry2qw1UX34Ut3y5trWfC3yYvF15AFZF9343Gr12qrZ5WayvvrW8GFW5
	Zr1S9rnxA3Z09aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UV89_UUUUU=
X-CM-SenderInfo: 52kd0zp2kd0qqrswhudrp/1tbiEBZ0d2cHRViEMAAAsM

On 2024/10/10 10:03, Kent Overstreet wrote:
> On Wed, Oct 09, 2024 at 10:07:55PM GMT, Zhao Mengmeng wrote:
>> From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>>
>> syzbot report a shift-out-of-bounds issue:
>> ------------[ cut here ]------------
>> UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
>> shift exponent 108 is too large for 32-bit type 'unsigned int'
>> ----
>> Here s.csum_granularity_bits = 108, so shift is impossible for unsigned
>> int. To fix, add a check in bch2_stripe_validate() to bail out, it has
>> same checking logic with ec_stripe_key_init().
>>
>> Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>> Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
>> Suggested-by: Hongbo Li <lihongbo22@huawei.com>
>> Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>> ---
>>  fs/bcachefs/ec.c      | 6 ++++++
>>  fs/bcachefs/errcode.h | 4 +++-
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
>> index 564841e5a24b..f6a02123144d 100644
>> --- a/fs/bcachefs/ec.c
>> +++ b/fs/bcachefs/ec.c
>> @@ -114,6 +114,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
>>  	const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
>>  	int ret = 0;
>>  
>> +	if (s->csum_granularity_bits >= ilog2(le16_to_cpu(s->sectors))) {
>> +		bch_err_ratelimited(c, "stripe csum gran bits %u too big",
>> +				    s->csum_granularity_bits);
>> +		return -BCH_ERR_stripe_csum_granularity_bits_too_big;
>> +	}
>> +
> 
> that should be a bkey_fsck_err_on(), and you'll add to the enum in
> sb-errors_format.h

Hi Kent, I try to use bkey_fsck_err_on() at the first time, but it still triggered
syzbot warning, cause bch2_stripe_to_text() is called before __bch2_fsck_err(), before
it throws new errro, it will trigger the shift out of bounds check.

Cheers!


