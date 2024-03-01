Received: from mail-108-mta97.mxroute.com (mail-108-mta97.mxroute.com [136.175.108.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99B03FE23
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 05:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709272395; cv=none; b=gW1d1hOMLSRDiLi3/qpDFCjdGBRQK16M7Ll8RBF46EDq/9JXfPe4V4XF+1bSU4M29WQ5og6wUqLfI1UkPnEDVFnYksKZP12k5gij6Nb+pmSY/5u9ei6XUrOVdPCDiV6ivkOyOKJIro1VIq06RVxWYUsqjeP1lpYigUKzV+wNUIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709272395; c=relaxed/simple;
	bh=3XTIwmGSQe2O26JtrW3tnJpUxADtMURDUHlroc1Apr0=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=XWSIRnFp3D1HO04dO4Q85LfQdlzUUQJwTPTV3g2RQLrcEf9i7Vhc+bIJUQbcUMhjMrTck8/0EjrJcCAhwCdE8HyXhG7tWyFcE8AgMgdzcCnQ65uEzH7GQCq5qVHrCFigcvULSd5esot4exQI7W2RC+BjR/4UxN2r7lE1xO6Qcdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=DFajT6Qz; arc=none smtp.client-ip=136.175.108.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="DFajT6Qz"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta97.mxroute.com (ZoneMTA) with ESMTPSA id 18df88e22410003bea.005
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Fri, 01 Mar 2024 05:48:00 +0000
X-Zone-Loop: cebf40ef9964dc9e16a855cbf1a3d92062053dfb0c9e
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	In-reply-to:Date:Subject:Cc:To:From:References:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ErJPVqVp8bE7HtbXACZbI+9rSXtYxkg2ePjAU3UIvrw=; b=DFajT6QzzQNPSeZs2wZrUH3p3m
	iJMfQs21R5hIwpchI5mZhykosyZfzyrh1g3k/jCHlm8bRsC+N/BDuzp2Qees18JipTlp1/5Jg9LzH
	glpO/U6CJuLFoeqk1vDM1SRx7BEnGuciWzQRRF7lF9nvRW+/vUG+cp8Jw/66Z4P4gNBqE79Ub28tx
	MjsQzefKsaruPqf6hYW6J3ACznT2N6YtRHUa2pEMeO2dUc+K8CcsmgJwGEf7gFRSNXbJGbzZTtE/X
	lYdSNVTxKHdUJwri55RHLyOegjNp5OKKvT2q9Cu6xqbMb0rCR+ocEI6+k/J/aM/mRWABBsiFd1Ltg
	iuBIW2NQ==;
References: <20240301031745.1912157-1-lihongbo22@huawei.com>
 <27c97dbd-cbc1-f6d3-9114-3eaf27d86c48@huawei.com>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Hongbo Li <lihongbo22@huawei.com>, kent.overstreet@linux.dev,
 bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: avoid returning private error code in
 bch2_xattr_bcachefs_set
Date: Fri, 01 Mar 2024 13:45:23 +0800
In-reply-to: <27c97dbd-cbc1-f6d3-9114-3eaf27d86c48@huawei.com>
Message-ID: <wmqmmrmd.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org


On Fri 01 Mar 2024 at 11:26, Jinjie Ruan <ruanjinjie@huawei.com>=20
wrote:

> On 2024/3/1 11:17, Hongbo Li wrote:
>> Avoid the private error code return to caller. The error code
>> should be transformed into genernal error code.
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>  fs/bcachefs/xattr.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
>> index 9c0d2316031b..754f17bba68e 100644
>> --- a/fs/bcachefs/xattr.c
>> +++ b/fs/bcachefs/xattr.c
>> @@ -544,11 +544,11 @@ static int bch2_xattr_bcachefs_set(const=20
>> struct xattr_handler *handler,
>>  		kfree(buf);
>>
>>  		if (ret < 0)
>> -			return ret;
>> +			goto err_class_exit;
>>
>>  		ret =3D bch2_opt_check_may_set(c, opt_id, v);
>>  		if (ret < 0)
>> -			return ret;
>> +			goto err_class_exit;
>>
>>  		s.v =3D v + 1;
>>  		s.defined =3D true;
>> @@ -595,6 +595,7 @@ static int bch2_xattr_bcachefs_set(const=20
>> struct xattr_handler *handler,
>>  	     (opt_id =3D=3D Opt_compression && !inode_opt_get(c,=20
>>  &inode->ei_inode, background_compression))))
>>  		bch2_set_rebalance_needs_scan(c,=20
>>  inode->ei_inode.bi_inum);
>>
>> +err_class_exit:
>>  	return bch2_err_class(ret);
>
> =E9=82=A3=E5=89=8D=E9=9D=A2=E7=9A=84return -ENOMEM=E5=92=8Creturn -EINVAL=
=E4=B8=8D=E7=94=A8=E8=BD=AC=E6=8D=A2=E5=90=97
>
Please reply in english. Thanks.

--
Su
>>  }
>>
