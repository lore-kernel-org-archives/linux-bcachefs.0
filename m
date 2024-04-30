Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BEC1118C
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Apr 2024 04:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714450446; cv=none; b=uHELup2MntM+j7wtrj3B4br3QnQ8MfjnrXIpzHw0Qwmc1M89Tsd7Ctqj20f6JunVGGyyvefLSHQGSo5nkKF1MmKlHyke6KsbokctDt+oVMpf2IDW64YCiBt1TsRHlDV4e8YzIdDnJpixXSxzDSyDk0AqTI1oIok/Vidw5kladr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714450446; c=relaxed/simple;
	bh=Q6DdmJVqJCfws1Srj4jcdR3dRP3+ld8JxaBObjp2YSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hH1B1IglG2X8c3q0E6I3YDRYYPUqALsSw+OtQn8/YeUlGo+IQjPrr6KE5iGHYPrEf3pfiRWJskG8jpkftT0AX/JXZE65CmYuTHisVB51Qt3OnRco9/YgNv7xLhmcla7Ou+xa4Cd1UbQ6ko+NvmLNnBbv676NK4COT/rSepYFObQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LO6c3VmP; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LO6c3VmP"
Message-ID: <2a595561-0a11-4d5e-ac72-a7c3aab9c8f7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714450441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMSdFBlDa/50RQbZivm8NN3gqBiYEydcILXMMCleMt4=;
	b=LO6c3VmPgnDaz1QPrnQoPOe3Fj5Wv+O3ytNuDttKJzxlasHW+UEmqk2z+BZMW+cOhBbTzw
	DmihLwz3ZvhjnTWnf8x8uuwTtf4ZsAPa75uyuTE5g3mt+DaQ88nrecS9r8T6LGu0c58lu6
	msSvpTtpQ0y4jVL3aO/Cy/Nv5xAVsDg=
Date: Tue, 30 Apr 2024 12:13:31 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: Correct the FS_IOC_GETFLAGS to
 FS_IOC32_GETFLAGS in bch2_compat_fs_ioctl()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20240430032744.943468-1-youling.tang@linux.dev>
 <penqmxyjpw5jukmqbmsrjbvqxhugrhbk6gruie4pjdoacah5zr@atcvnu6ogksv>
Content-Language: en-US, en-AU
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <penqmxyjpw5jukmqbmsrjbvqxhugrhbk6gruie4pjdoacah5zr@atcvnu6ogksv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 30/04/2024 11:29, Kent Overstreet wrote:
> On Tue, Apr 30, 2024 at 11:27:44AM +0800, Youling Tang wrote:
>> From: Youling Tang <tangyouling@kylinos.cn>
>>
>> It should be FS_IOC32_GETFLAGS instead of FS_IOC_GETFLAGS in
>> compat ioctl.
> Do we by chance have a test for this?

Just reading the code found this out.


>
>> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
>> ---
>>   fs/bcachefs/fs-ioctl.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
>> index 3dc8630ff9fe..205a323ffc6d 100644
>> --- a/fs/bcachefs/fs-ioctl.c
>> +++ b/fs/bcachefs/fs-ioctl.c
>> @@ -548,7 +548,7 @@ long bch2_compat_fs_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>>   {
>>   	/* These are just misnamed, they actually get/put from/to user an int */
>>   	switch (cmd) {
>> -	case FS_IOC_GETFLAGS:
>> +	case FS_IOC32_GETFLAGS:
>>   		cmd = FS_IOC_GETFLAGS;
>>   		break;
>>   	case FS_IOC32_SETFLAGS:
>> -- 
>> 2.34.1
>>
