Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB12816087B;
	Mon, 27 May 2024 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836492; cv=none; b=nEOYq77MzjX+92uxski1JUYq32xfRFtRYgAlHyCf8Uf83y/OPdrpPkzRQ74ePRy9Rmxv/hNHzRTvs81rQ/TC6DuvFr7bW5VF4BwF1oEYWBvdmHDOMEjOdi9RqcSQAE/YGCvrzl/EqKNkwu9bGfCXR4cgHI5kDTtd8K6gRvPpjXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836492; c=relaxed/simple;
	bh=W++HowwQqIlSrfLaRS0YW9hyQBNQRnsjM6WKEKiBfE0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=nkmREDRG2du8+nofodUb07XhyFBkCN8b8/Ge71jQduoA0X1bAKHnW26kQpnN2evhRlRDf3iNQYYHc5lUV0F2bN1VHG94ZCZPGdMdxN5O498rMFTmX930GNKfmKWglil2JDeUdL6l1Hetrk3bcxMIrNoshwjIyIsIRHlGyls0Bp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=WX8oLSc4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="WX8oLSc4"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44RAp7UO028118;
	Mon, 27 May 2024 19:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Dalwtp46ylm694N63E5I/9
	BWEBTB6ns/nMr5wPY70Xs=; b=WX8oLSc4R5OP3INbGHskpz6wJQyG0Qxp5ugMvr
	RIksnOM5n1J7gcHrHo0CAwvK75C7f/gY+e8VehlFsD7B9Orc/iPmJQi4cQRP5CX7
	lIwp6wr4JJFQg5Snc/6qCE1aqbB2Tc/HtlRllL/x41GMZMkk5NxsDLAdI191BBu0
	1dLjZin9oUGzXHwQ/cZZNsx6y+WE2aCGh5BfiggzAvvibNOl840aIzCzRkNr4ap9
	9c9UR9GAp0tIARc43txeE20PmBlLE49zXESbwsCagvXDgHI+KqjA8zl95QCviq7Y
	mzVawMoIGIp84wInL44hzHtCfrKxJbvjNW/107m4pvtpdW5A==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yba2pmgk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 May 2024 19:01:24 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44RJ1Mfc028688
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 May 2024 19:01:22 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 27 May
 2024 12:01:21 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Mon, 27 May 2024 12:01:18 -0700
Subject: [PATCH] fs: bcachefs: add missing MODULE_DESCRIPTION()
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240527-md-fs-bcachefs-v1-1-d6dbb1143091@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAH3YVGYC/x3MQQrCMBCF4auUWTsQQ0uoVxEXk+nEDNgoGSuF0
 rubdve+xfs3MKkqBrdugyo/NX2XhuulA85UnoI6NYN3vneDDzhPmAwjE2dpg9Mwhj6EMXkH7fS
 pknQ9g/dHcyQTjJUK5yPz0rKsOJN9pcK+/wETEIabfwAAAA==
To: Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster
	<bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 9M1LHllfcpkxyjHDRw3HOB47yMmIatND
X-Proofpoint-ORIG-GUID: 9M1LHllfcpkxyjHDRw3HOB47yMmIatND
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-27_04,2024-05-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 spamscore=0 adultscore=0 clxscore=1011 bulkscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405270156

Fix the 'make W=1' warning:
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/bcachefs/mean_and_variance_test.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 fs/bcachefs/mean_and_variance_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/mean_and_variance_test.c b/fs/bcachefs/mean_and_variance_test.c
index 4c298e74723d..e9d9c0212e44 100644
--- a/fs/bcachefs/mean_and_variance_test.c
+++ b/fs/bcachefs/mean_and_variance_test.c
@@ -217,4 +217,5 @@ static struct kunit_suite mean_and_variance_test_suite = {
 kunit_test_suite(mean_and_variance_test_suite);
 
 MODULE_AUTHOR("Daniel B. Hill");
+MODULE_DESCRIPTION("bcachefs filesystem mean and variance unit tests");
 MODULE_LICENSE("GPL");

---
base-commit: 2bfcfd584ff5ccc8bb7acde19b42570414bf880b
change-id: 20240527-md-fs-bcachefs-cf5974779f20

