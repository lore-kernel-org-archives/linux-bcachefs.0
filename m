Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03981FA3
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Apr 2024 02:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713322246; cv=none; b=OPlct5xorIjydwBHhSdN9FQATeb44QTTlowxbwumZelCKv8N/JJgH5DMDNDZEnkP1ccCf6W5q+rEuOw+zq23f4y9E0btFTcuZYdI9zCokajVxaduxTj4f2HCxLBQ85l+REDy3/mAnksy1h2+6tbZPIP7lLXII/fKORYGnC0dycc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713322246; c=relaxed/simple;
	bh=/FDO3Uw9+p8ydkHOVunFPN9wYZTRJmeTTdMPpt00iKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OllpRrq8HjWN/Qm3NeBzkQf0e1iNmxy/COTN/umjg4xYuFi+HXsorK8GpJ/bVyqFKbAAOrEBol71tsvFFmiy80vmOza7i6kF1IHNbGu0WRaY7ocIgkwU9iofUIMMc2Yd3pHKe/Qn6KY/1X9weY6VooaxxIf+U2RTcU2BW69p6PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LA57phaG; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LA57phaG"
Message-ID: <66ecea56-e4d3-4241-a1dc-378d70555321@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713322240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/rtQZtLs/mz2eWV/Bg/16BoPls0vGnu3jMo7OCv9/g=;
	b=LA57phaG9cFvsxw3USySWeg4HYSn9eWdLVuJ1mszLR880/JyyNEt5h+5hPE6Me34Qqh19u
	Fac801LkcsF623K4yvXzi7yw9LoWNA3U258CUKSDGNDYb+aAUqy1tDPkBMFDPcUoxMvRr9
	WJqt/xQjGc9EypiYyhhDlhdn9fdHkPQ=
Date: Wed, 17 Apr 2024 10:50:10 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: Align the display format of
 `btrees/inodes/keys`
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20240417015448.84294-1-youling.tang@linux.dev>
 <toosz4pt2la6wf2575vwe6efebcbzsy735cq7exmlqhzrgicrf@s7g3rrbvge2l>
Content-Language: en-US, en-AU
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <toosz4pt2la6wf2575vwe6efebcbzsy735cq7exmlqhzrgicrf@s7g3rrbvge2l>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi, Kent
On 17/04/2024 10:20, Kent Overstreet wrote:
> On Wed, Apr 17, 2024 at 09:54:48AM +0800, Youling Tang wrote:
>> From: Youling Tang <tangyouling@kylinos.cn>
>>
>> Before patch:
>> ```
>>   #cat btrees/inodes/keys
>>   u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:   mode=40755
>>     flags= (16300000)
>> ```
>>
>> After patch:
>> ```
>>   #cat btrees/inodes/keys
>>   u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:
>>     mode=40755
>>     flags= (16300000)
> This would print a newline for keys that don't have a value...
The original intention was to make the display of the printed content in
'__bch2_inode_unpacked_to_text ()' consistent, without considering other 
callbacks.

Or just modify it in the following way?
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -534,6 +534,8 @@ int bch2_inode_v3_invalid(struct bch_fs *c, struct 
bkey_s_c k,
  static void __bch2_inode_unpacked_to_text(struct printbuf *out,
struct bch_inode_unpacked *inode)
  {
+       prt_newline(out);
+
         printbuf_indent_add(out, 2);
         prt_printf(out, "mode=%o", inode->bi_mode);
         prt_newline(out);


Thanks,
Youling.
