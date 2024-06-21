Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02226110A
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jun 2024 01:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718932333; cv=none; b=LzU5z9QhpZXDu0wxBBavayaXIdVXjUR0x00tGw+dCf9l99TdCsVXCtTkDJn5jvL1A4Abla2hRTHSJNZx2i0WgTYiS79NPLJZFXMQVqKQVHd6fG5+20jwcLgi1Q8kWxc9IQTPubAURnEjqaAHuSaeQYBxS58yEIaMsBBA0o3ZzJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718932333; c=relaxed/simple;
	bh=S3canZcKahQeI0EJf5EI0Jhp2mTHLS0AOfjT7/IR5iI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XtMkIBxmm5HozlfuTGcCPMj+BT2hN718/bOOzx8GA0sc3KhSQjhSfJtHkpAvjgfifeBixikG26fwYD1d/psdAirKfhQiMaFMnzqeM/ZqZLon5zRnYsXAKAhkVj9YDfwhyfM3QUlprJcP77Hajh2eDgKERcBEOsevRZp1xpThu/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WU52wQeh; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WU52wQeh"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718932328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3canZcKahQeI0EJf5EI0Jhp2mTHLS0AOfjT7/IR5iI=;
	b=WU52wQehGB5IlWBEWmiAAL9u4Mb1QIDVilAegPqxImKz+LB0smUJPEJ3SJVla593LB6uLf
	rn7g9vdbp1qKBXoSIRDmq/aQ4FcMps73sd9i1r2AsT5aXLuUGPC2BN0/vfDjWxbdStae/y
	fQUT0chhwP4Wmu6ydlMO5q2gNhehnxw=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
Message-ID: <c24f044a-989d-4661-812d-3e2140f1f626@linux.dev>
Date: Fri, 21 Jun 2024 09:11:52 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: fix alignment of VMA for memory mapped files on
 THP
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20240620012242.106698-1-youling.tang@linux.dev>
 <myw2h2mm7725gegy6pbqf4qpzghrfypnlbn4z6rh6idwfjzpjc@chzxxg47sw77>
Content-Language: en-US, en-AU
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <myw2h2mm7725gegy6pbqf4qpzghrfypnlbn4z6rh6idwfjzpjc@chzxxg47sw77>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi, Kent

Sorry to bother you, BTW, are the following patches still needed?

https://lore.kernel.org/linux-bcachefs/20240604084610.94558-1-youling.tang@linux.dev/
https://lore.kernel.org/linux-bcachefs/20240418083103.66703-1-youling.tang@linux.dev/
https://lore.kernel.org/linux-bcachefs/20240418005055.45482-1-youling.tang@linux.dev/

Thanks,
Youling.

On 20/06/2024 20:51, Kent Overstreet wrote:
> On Thu, Jun 20, 2024 at 09:22:42AM +0800, Youling Tang wrote:
>> From: Youling Tang <tangyouling@kylinos.cn>
>>
>> With CONFIG_READ_ONLY_THP_FOR_FS, the Linux kernel supports using THPs
>> for read-only mmapped files, such as shared libraries. However, the
>> kernel makes no attempt to actually align those mappings on 2MB
>> boundaries, which makes it impossible to use those THPs most of the
>> time. This issue applies to general file mapping THP as well as
>> existing setups using CONFIG_READ_ONLY_THP_FOR_FS. This is easily
>> fixed by using thp_get_unmapped_area for the unmapped_area function
>> in bcachefs, which is what ext2, ext4, fuse, xfs and btrfs all use.
>>
>> Similar to commit b0c582233a85 ("btrfs: fix alignment of VMA for
>> memory mapped files on THP").
>>
>> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> Thanks - applied

