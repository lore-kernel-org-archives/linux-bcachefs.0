Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112C41AB52C
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727193607; cv=none; b=jXmqJZRJStMsqrNHC0HNU9kdsXFoshdO/hmrhbeorJMyEAXKYaU3TpSM6HnVu2mkfk6z6VOQaLRQ2A3WueZGjmKhMr79mHsiwRC9DkwcsOYGZ6px0xIgvvPIEjpXHO51EKDyeDtk2WO/YrS9F2MyVJGAnUA0zDA5g/FIdJCQWH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727193607; c=relaxed/simple;
	bh=DDoFgYyBuTnY466Y8lUCUi9TMrxtQ04HKwXpdjTFqEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXVQqwIVlbalesqg/RbWDSPZuMTnbWjsAejPto8WeHCVjGxRkkVU5ljVZM3/ftPT6a9Y2o/eaHxAHRwnEcNbUkIhik6aurENOe1mIcN1b1wNtYUiUT3RalAU9tIDkVSqBefhAC65qikciYETt51vsN+JGVYJa5CY+BXsFcisVtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZmAqU/9C; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZmAqU/9C"
Date: Tue, 24 Sep 2024 11:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727193600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1ZA8DtfHjGey/c6txAU6UB1ZGf9pVNbcE19KDku/zk=;
	b=ZmAqU/9CbteQ1Y4o7YqqpqC/wnGCQrq5tYhZ282D+0/N4UwgjJW2VCI2NlQ/6B6SbVYJ6x
	fDa/LbwsN7MLHtijKRgcAOK7k+vwCa7zfTSGGo7efs5EEYJe9J/WUUI8c6GcTYOSXwiqYU
	LW1gDsH5TdZwIRug/E8PALUWbnePGPE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "zhangjianhua (E)" <chris.zjh@huawei.com>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fast exit when darray_make_room failed
Message-ID: <tctwydscsvvfmtxc6cqcho26zdo6pobnpuu72fxjvvaulf5ose@pam2e47tnac2>
References: <20240924014224.701966-1-lihongbo22@huawei.com>
 <05e88e7c-403e-41e7-88ed-b109f107e81c@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05e88e7c-403e-41e7-88ed-b109f107e81c@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 24, 2024 at 09:44:52PM GMT, zhangjianhua (E) wrote:
> 
> 在 2024/9/24 9:42, Hongbo Li 写道:
> > In downgrade_table_extra, the return value is needed. When it
> > return failed, we should exit immediately.
> 
> 补丁标题讲的是函数失败后快速退出，很难理解fast的意义。
> 
> 最好描述下当前代码会有什么问题，这样更有说服力。

English on the list, please... I'll start learning Chinese after I finish with Spanish :)
